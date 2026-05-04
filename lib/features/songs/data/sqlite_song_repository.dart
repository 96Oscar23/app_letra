import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../domain/song.dart';
import '../domain/song_tag.dart';
import 'song_repository.dart';

class SqliteSongRepository implements SongRepository {
  SqliteSongRepository(this._database);

  final Database _database;

  @override
  Future<int> createSong(Song song) async {
    final songId = await _database.insert('songs', song.toMap()..remove('id'));
    await _syncSongTagsFromLabels(
      songId,
      song.tags,
      fallbackTimestamp: song.createdAt,
    );
    return songId;
  }

  @override
  Future<void> deleteSong(int id) async {
    await _database.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Song?> findById(int id) async {
    final rows = await _database.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    final songs = await _hydrateSongs(rows);
    return songs.isEmpty ? null : songs.first;
  }

  @override
  Future<List<Song>> fetchSongs({
    String query = '',
    bool favoritesOnly = false,
    bool recentOnly = false,
    Set<String> categories = const {},
    Set<String> artists = const {},
    Set<String> genres = const {},
    Set<String> tags = const {},
  }) async {
    final filters = <String>[];
    final args = <Object?>[];
    final trimmed = query.trim();

    if (favoritesOnly) {
      filters.add('is_favorite = ?');
      args.add(1);
    }
    if (recentOnly) {
      filters.add("last_opened_at IS NOT NULL AND TRIM(last_opened_at) <> ''");
    }
    if (trimmed.isNotEmpty) {
      filters.add('(title LIKE ? OR lyrics LIKE ? OR author LIKE ?)');
      final like = '%$trimmed%';
      args.addAll([like, like, like]);
    }
    if (categories.isNotEmpty) {
      final placeholders = List.filled(categories.length, '?').join(', ');
      filters.add('LOWER(category) IN ($placeholders)');
      args.addAll(categories.map((value) => value.trim().toLowerCase()));
    }
    if (artists.isNotEmpty) {
      final placeholders = List.filled(artists.length, '?').join(', ');
      filters.add('LOWER(author) IN ($placeholders)');
      args.addAll(artists.map((value) => value.trim().toLowerCase()));
    }
    if (genres.isNotEmpty) {
      final placeholders = List.filled(genres.length, '?').join(', ');
      filters.add('LOWER(genre) IN ($placeholders)');
      args.addAll(genres.map((value) => value.trim().toLowerCase()));
    }
    if (tags.isNotEmpty) {
      final placeholders = List.filled(tags.length, '?').join(', ');
      filters.add('''
        EXISTS (
          SELECT 1
          FROM song_tag_links stl
          INNER JOIN song_tags st ON st.id = stl.tag_id
          WHERE stl.song_id = songs.id
            AND LOWER(st.name) IN ($placeholders)
        )
      ''');
      args.addAll(tags.map((value) => value.trim().toLowerCase()));
    }

    final rows = await _database.query(
      'songs',
      where: filters.isEmpty ? null : filters.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: recentOnly
          ? 'last_opened_at DESC, title COLLATE NOCASE ASC'
          : 'is_favorite DESC, updated_at DESC, title COLLATE NOCASE ASC',
    );

    return _hydrateSongs(rows);
  }

  @override
  Future<List<SongTag>> fetchTags() async {
    final rows = await _database.rawQuery('''
      SELECT
        st.id,
        st.name,
        st.type,
        st.created_at,
        st.updated_at,
        COUNT(stl.song_id) AS usage_count
      FROM song_tags st
      LEFT JOIN song_tag_links stl ON stl.tag_id = st.id
      GROUP BY st.id, st.name, st.type, st.created_at, st.updated_at
      ORDER BY
        CASE st.type WHEN 'temporada_evento' THEN 0 ELSE 1 END,
        st.name COLLATE NOCASE ASC
    ''');
    return rows.map(SongTag.fromMap).toList();
  }

  @override
  Future<List<SongTag>> fetchTagsForSong(int songId) async {
    final rows = await _database.rawQuery(
      '''
      SELECT
        st.id,
        st.name,
        st.type,
        st.created_at,
        st.updated_at,
        COUNT(all_links.song_id) AS usage_count
      FROM song_tag_links selected_links
      INNER JOIN song_tags st ON st.id = selected_links.tag_id
      LEFT JOIN song_tag_links all_links ON all_links.tag_id = st.id
      WHERE selected_links.song_id = ?
      GROUP BY st.id, st.name, st.type, st.created_at, st.updated_at
      ORDER BY st.name COLLATE NOCASE ASC
      ''',
      [songId],
    );
    return rows.map(SongTag.fromMap).toList();
  }

  @override
  Future<int> createTag(SongTag tag) async {
    final name = tag.name.trim();
    if (name.isEmpty) {
      throw StateError('La etiqueta no puede estar vacia.');
    }
    await _assertTagNameAvailable(name, excludingId: tag.id);
    return _database.insert(
        'song_tags', tag.copyWith(name: name).toMap()..remove('id'));
  }

  @override
  Future<void> updateTag(SongTag tag) async {
    if (tag.id == null) {
      throw StateError('La etiqueta no tiene id para actualizarse.');
    }
    final name = tag.name.trim();
    if (name.isEmpty) {
      throw StateError('La etiqueta no puede estar vacia.');
    }
    await _assertTagNameAvailable(name, excludingId: tag.id);
    await _database.update(
      'song_tags',
      tag.copyWith(name: name).toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
    await _syncSongRowsFromTagLinks();
  }

  @override
  Future<void> deleteTag(int id) async {
    await _database.delete('song_tags', where: 'id = ?', whereArgs: [id]);
    await _syncSongRowsFromTagLinks();
  }

  @override
  Future<void> replaceSongTags(int songId, List<int> tagIds) async {
    final now = DateTime.now().toIso8601String();
    final normalized = tagIds.toSet().toList()..sort();

    await _database.transaction((txn) async {
      await txn.delete(
        'song_tag_links',
        where: 'song_id = ?',
        whereArgs: [songId],
      );
      for (final tagId in normalized) {
        await txn.insert(
          'song_tag_links',
          {
            'song_id': songId,
            'tag_id': tagId,
            'created_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });

    await _syncSongRowsFromTagLinks(songIds: [songId]);
  }

  @override
  Future<void> seedInitialSongsIfEmpty() async {
    final count = Sqflite.firstIntValue(
          await _database.rawQuery('SELECT COUNT(*) FROM songs'),
        ) ??
        0;
    if (count > 0) {
      return;
    }

    final now = DateTime.now();
    await createSong(
      Song(
        title: 'Great Is Thy Faithfulness',
        lyrics:
            'Great is Thy faithfulness...\nMorning by morning new mercies I see.',
        baseKey: 'Eb',
        author: 'Thomas Chisholm',
        category: 'Adoracion',
        genre: 'Himno',
        notes: 'Seed inicial de la fase 1.',
        capo: '',
        bpm: 72,
        tags: const ['Clasico', 'Adoracion'],
        status: SongStatuses.active,
        isFavorite: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await createSong(
      Song(
        title: 'Celebracion de la Luz',
        lyrics: 'Eres la luz que alumbra mi camino y mi cancion.',
        baseKey: 'G',
        author: 'Ministerio local',
        category: 'Entrada',
        genre: 'Worship',
        notes: '',
        capo: '',
        bpm: 68,
        tags: const ['Entrada'],
        status: SongStatuses.active,
        isFavorite: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> updateSong(Song song) async {
    await _database.update(
      'songs',
      song.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [song.id],
    );
    if (song.id != null) {
      await _syncSongTagsFromLabels(
        song.id!,
        song.tags,
        fallbackTimestamp: song.updatedAt,
      );
    }
  }

  Future<List<Song>> _hydrateSongs(List<Map<String, Object?>> rows) async {
    if (rows.isEmpty) {
      return const [];
    }

    final songIds = rows.map((row) => row['id'] as int).toList();
    final placeholders = List.filled(songIds.length, '?').join(', ');
    final tagRows = await _database.rawQuery(
      '''
      SELECT stl.song_id, st.name
      FROM song_tag_links stl
      INNER JOIN song_tags st ON st.id = stl.tag_id
      WHERE stl.song_id IN ($placeholders)
      ORDER BY st.name COLLATE NOCASE ASC
      ''',
      songIds,
    );

    final tagsBySongId = <int, List<String>>{};
    for (final row in tagRows) {
      final songId = row['song_id'] as int?;
      final tagName = row['name'] as String?;
      if (songId == null || tagName == null || tagName.trim().isEmpty) {
        continue;
      }
      tagsBySongId.putIfAbsent(songId, () => []).add(tagName.trim());
    }

    return rows.map((row) {
      final hydratedRow = Map<String, Object?>.from(row);
      final songId = row['id'] as int?;
      final tags = songId == null ? null : tagsBySongId[songId];
      if (tags != null) {
        hydratedRow['tags'] = jsonEncode(tags);
      }
      return Song.fromMap(hydratedRow);
    }).toList();
  }

  Future<void> _assertTagNameAvailable(
    String name, {
    int? excludingId,
  }) async {
    final rows = await _database.query(
      'song_tags',
      columns: ['id'],
      where: excludingId == null
          ? 'LOWER(name) = ?'
          : 'LOWER(name) = ? AND id != ?',
      whereArgs: excludingId == null
          ? [name.toLowerCase()]
          : [name.toLowerCase(), excludingId],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      throw StateError('Ya existe una etiqueta con ese nombre.');
    }
  }

  Future<void> _syncSongTagsFromLabels(
    int songId,
    Iterable<String> labels, {
    required DateTime fallbackTimestamp,
  }) async {
    final normalizedLabels = labels
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final tagIds = <int>[];
    for (final label in normalizedLabels) {
      final existingRows = await _database.query(
        'song_tags',
        columns: ['id'],
        where: 'LOWER(name) = ?',
        whereArgs: [label.toLowerCase()],
        limit: 1,
      );
      if (existingRows.isNotEmpty) {
        tagIds.add(existingRows.first['id'] as int);
        continue;
      }

      final tagId = await _database.insert('song_tags', {
        'name': label,
        'type': SongTagTypes.custom,
        'created_at': fallbackTimestamp.toIso8601String(),
        'updated_at': fallbackTimestamp.toIso8601String(),
      });
      tagIds.add(tagId);
    }

    await replaceSongTags(songId, tagIds);
  }

  Future<void> _syncSongRowsFromTagLinks({List<int>? songIds}) async {
    final ids = songIds ??
        (await _database.query('songs', columns: ['id']))
            .map((row) => row['id'] as int)
            .toList();

    if (ids.isEmpty) {
      return;
    }

    final placeholders = List.filled(ids.length, '?').join(', ');
    final tagRows = await _database.rawQuery(
      '''
      SELECT stl.song_id, st.name
      FROM song_tag_links stl
      INNER JOIN song_tags st ON st.id = stl.tag_id
      WHERE stl.song_id IN ($placeholders)
      ORDER BY st.name COLLATE NOCASE ASC
      ''',
      ids,
    );

    final tagsBySongId = <int, List<String>>{};
    for (final row in tagRows) {
      final songId = row['song_id'] as int?;
      final name = row['name'] as String?;
      if (songId == null || name == null || name.trim().isEmpty) {
        continue;
      }
      tagsBySongId.putIfAbsent(songId, () => []).add(name.trim());
    }

    final batch = _database.batch();
    for (final songId in ids) {
      batch.update(
        'songs',
        {
          'tags': jsonEncode(tagsBySongId[songId] ?? const <String>[]),
        },
        where: 'id = ?',
        whereArgs: [songId],
      );
    }
    await batch.commit(noResult: true);
  }
}
