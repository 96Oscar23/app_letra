import 'package:sqflite/sqflite.dart';

import '../domain/song.dart';
import 'song_repository.dart';

class SqliteSongRepository implements SongRepository {
  SqliteSongRepository(this._database);

  final Database _database;

  @override
  Future<int> createSong(Song song) async =>
      _database.insert('songs', song.toMap()..remove('id'));

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
    return rows.isEmpty ? null : Song.fromMap(rows.first);
  }

  @override
  Future<List<Song>> fetchSongs({
    String query = '',
    bool favoritesOnly = false,
  }) async {
    final filters = <String>[];
    final args = <Object?>[];
    final trimmed = query.trim();

    if (favoritesOnly) {
      filters.add('is_favorite = ?');
      args.add(1);
    }
    if (trimmed.isNotEmpty) {
      filters.add('(title LIKE ? OR lyrics LIKE ? OR author LIKE ?)');
      final like = '%$trimmed%';
      args.addAll([like, like, like]);
    }

    final rows = await _database.query(
      'songs',
      where: filters.isEmpty ? null : filters.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'is_favorite DESC, updated_at DESC, title COLLATE NOCASE ASC',
    );

    return rows.map(Song.fromMap).toList();
  }

  @override
  Future<void> seedInitialSongsIfEmpty() async {
    final count = Sqflite.firstIntValue(
            await _database.rawQuery('SELECT COUNT(*) FROM songs')) ??
        0;
    if (count > 0) return;

    final now = DateTime.now().toIso8601String();
    await _database.insert('songs', {
      'title': 'Great Is Thy Faithfulness',
      'lyrics':
          'Great is Thy faithfulness...\\nMorning by morning new mercies I see.',
      'base_key': 'Eb',
      'author': 'Thomas Chisholm',
      'category': 'Adoracion',
      'notes': 'Seed inicial de la fase 1.',
      'capo': '',
      'bpm': 72,
      'tags': '["clasico","adoracion"]',
      'status': SongStatuses.active,
      'is_favorite': 1,
      'created_at': now,
      'updated_at': now,
    });
    await _database.insert('songs', {
      'title': 'Celebracion de la Luz',
      'lyrics': 'Eres la luz que alumbra mi camino y mi cancion.',
      'base_key': 'G',
      'author': 'Ministerio local',
      'category': 'Entrada',
      'notes': '',
      'capo': '',
      'bpm': 68,
      'tags': '["entrada"]',
      'status': SongStatuses.active,
      'is_favorite': 0,
      'created_at': now,
      'updated_at': now,
    });
  }

  @override
  Future<void> updateSong(Song song) async {
    await _database.update(
      'songs',
      song.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }
}
