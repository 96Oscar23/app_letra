import '../domain/song.dart';
import '../domain/song_tag.dart';
import 'song_repository.dart';

class InMemorySongRepository implements SongRepository {
  InMemorySongRepository({
    List<Song>? initialSongs,
    List<SongTag>? initialTags,
  })  : _songs = [...?initialSongs],
        _tags = [...?initialTags] {
    for (final song in _songs) {
      if (song.id != null && song.id! >= _nextId) {
        _nextId = song.id! + 1;
      }
    }
    for (final tag in _tags) {
      if (tag.id != null && tag.id! >= _nextTagId) {
        _nextTagId = tag.id! + 1;
      }
    }
    _bootstrapTagsFromSongs();
  }

  final List<Song> _songs;
  final List<SongTag> _tags;
  final Map<int, Set<int>> _songTagIds = {};
  int _nextId = 1;
  int _nextTagId = 1;

  @override
  Future<int> createSong(Song song) async {
    final created = song.copyWith(id: _nextId++);
    _songs.add(created);
    if (created.id != null) {
      await _syncSongTagsFromLabels(created.id!, created.tags);
    }
    return created.id!;
  }

  @override
  Future<void> deleteSong(int id) async {
    _songs.removeWhere((song) => song.id == id);
    _songTagIds.remove(id);
  }

  @override
  Future<Song?> findById(int id) async {
    for (final song in _songs) {
      if (song.id == id) {
        return _hydrateSong(song);
      }
    }
    return null;
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
    final normalizedQuery = query.toLowerCase().trim();
    final normalizedCategories =
        categories.map((item) => item.toLowerCase()).toSet();
    final normalizedArtists = artists.map((item) => item.toLowerCase()).toSet();
    final normalizedGenres = genres.map((item) => item.toLowerCase()).toSet();
    final normalizedTags = tags.map((item) => item.toLowerCase()).toSet();

    return _songs.map(_hydrateSong).where((song) {
      final passesFavorite = !favoritesOnly || song.isFavorite;
      final passesRecent = !recentOnly || song.lastOpenedAt != null;
      final haystack = [
        song.title,
        song.lyrics,
        song.author,
        song.category,
        song.genre,
        song.notes,
        ...song.tags,
      ].join(' ').toLowerCase();
      final passesQuery =
          normalizedQuery.isEmpty || haystack.contains(normalizedQuery);
      final passesCategory = normalizedCategories.isEmpty ||
          normalizedCategories.contains(song.category.toLowerCase());
      final passesArtist = normalizedArtists.isEmpty ||
          normalizedArtists.contains(song.author.toLowerCase());
      final passesGenre = normalizedGenres.isEmpty ||
          normalizedGenres.contains(song.genre.toLowerCase());
      final songTags = song.tags.map((item) => item.toLowerCase()).toSet();
      final passesTags =
          normalizedTags.isEmpty || normalizedTags.any(songTags.contains);

      return passesFavorite &&
          passesRecent &&
          passesQuery &&
          passesCategory &&
          passesArtist &&
          passesGenre &&
          passesTags;
    }).toList()
      ..sort((a, b) {
        if (recentOnly) {
          final left = a.lastOpenedAt;
          final right = b.lastOpenedAt;
          if (left == null && right == null) {
            return a.title.compareTo(b.title);
          }
          if (left == null) {
            return 1;
          }
          if (right == null) {
            return -1;
          }
          final byDate = right.compareTo(left);
          return byDate != 0 ? byDate : a.title.compareTo(b.title);
        }
        final byFavorite = (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0);
        if (byFavorite != 0) {
          return byFavorite;
        }
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }

  @override
  Future<List<SongTag>> fetchTags() async {
    final mapped = _tags.map(_withUsageCount).toList();
    mapped.sort((a, b) {
      if (a.type != b.type) {
        if (a.type == SongTagTypes.seasonEvent) {
          return -1;
        }
        if (b.type == SongTagTypes.seasonEvent) {
          return 1;
        }
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return mapped;
  }

  @override
  Future<List<SongTag>> fetchTagsForSong(int songId) async {
    final selectedIds = _songTagIds[songId] ?? const <int>{};
    return _tags
        .where((tag) => tag.id != null && selectedIds.contains(tag.id))
        .map(_withUsageCount)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Future<int> createTag(SongTag tag) async {
    final normalized = tag.name.trim();
    if (normalized.isEmpty) {
      throw StateError('La etiqueta no puede estar vacia.');
    }
    _assertTagNameAvailable(normalized, excludingId: tag.id);
    final created = tag.copyWith(
      id: _nextTagId++,
      name: normalized,
    );
    _tags.add(created);
    return created.id!;
  }

  @override
  Future<void> updateTag(SongTag tag) async {
    if (tag.id == null) {
      throw StateError('La etiqueta no tiene id para actualizarse.');
    }
    final normalized = tag.name.trim();
    if (normalized.isEmpty) {
      throw StateError('La etiqueta no puede estar vacia.');
    }
    _assertTagNameAvailable(normalized, excludingId: tag.id);
    final index = _tags.indexWhere((item) => item.id == tag.id);
    if (index != -1) {
      _tags[index] = tag.copyWith(name: normalized);
      _syncSongRowsFromAssignments();
    }
  }

  @override
  Future<void> deleteTag(int id) async {
    _tags.removeWhere((tag) => tag.id == id);
    for (final entry in _songTagIds.entries) {
      entry.value.remove(id);
    }
    _syncSongRowsFromAssignments();
  }

  @override
  Future<void> replaceSongTags(int songId, List<int> tagIds) async {
    _songTagIds[songId] = tagIds.toSet();
    _syncSongRowsFromAssignments(songIds: [songId]);
  }

  @override
  Future<void> seedInitialSongsIfEmpty() async {
    if (_songs.isNotEmpty) {
      return;
    }

    final now = DateTime(2026, 4, 1, 12);
    await createSong(
      Song(
        title: 'Great Is Thy Faithfulness',
        lyrics: 'Great is Thy faithfulness...',
        baseKey: 'Eb',
        author: 'Thomas Chisholm',
        category: 'Adoracion',
        genre: 'Himno',
        notes: 'Version congregacional.',
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
        lyrics: 'Eres la luz que alumbra...',
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
    final index = _songs.indexWhere((item) => item.id == song.id);
    if (index != -1) {
      _songs[index] = song;
      if (song.id != null) {
        await _syncSongTagsFromLabels(song.id!, song.tags);
      }
    }
  }

  Song _hydrateSong(Song song) {
    final ids = song.id == null
        ? const <int>{}
        : (_songTagIds[song.id!] ?? const <int>{});
    final hydratedTags = _tags
        .where((tag) => tag.id != null && ids.contains(tag.id))
        .map((tag) => tag.name)
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return song.copyWith(tags: hydratedTags);
  }

  SongTag _withUsageCount(SongTag tag) {
    final count =
        _songTagIds.values.where((ids) => ids.contains(tag.id)).length;
    return tag.copyWith(usageCount: count);
  }

  Future<void> _syncSongTagsFromLabels(
      int songId, Iterable<String> labels) async {
    final tagIds = <int>[];
    final normalizedLabels = labels
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (final label in normalizedLabels) {
      final existing =
          _tags.where((tag) => tag.name.toLowerCase() == label.toLowerCase());
      if (existing.isNotEmpty) {
        tagIds.add(existing.first.id!);
        continue;
      }
      final created = SongTag(
        id: _nextTagId++,
        name: label,
        type: SongTagTypes.custom,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _tags.add(created);
      tagIds.add(created.id!);
    }

    _songTagIds[songId] = tagIds.toSet();
    _syncSongRowsFromAssignments(songIds: [songId]);
  }

  void _bootstrapTagsFromSongs() {
    for (final song in _songs) {
      if (song.id == null) {
        continue;
      }
      final tagIds = <int>{};
      for (final label in song.tags) {
        if (label.trim().isEmpty) {
          continue;
        }
        final existing =
            _tags.where((tag) => tag.name.toLowerCase() == label.toLowerCase());
        SongTag resolvedTag;
        if (existing.isNotEmpty) {
          resolvedTag = existing.first;
        } else {
          resolvedTag = SongTag(
            id: _nextTagId++,
            name: label.trim(),
            type: SongTagTypes.custom,
            createdAt: song.createdAt,
            updatedAt: song.updatedAt,
          );
          _tags.add(resolvedTag);
        }
        tagIds.add(resolvedTag.id!);
      }
      _songTagIds[song.id!] = tagIds;
    }
    _syncSongRowsFromAssignments();
  }

  void _syncSongRowsFromAssignments({List<int>? songIds}) {
    final targets = songIds?.toSet();
    for (var index = 0; index < _songs.length; index++) {
      final song = _songs[index];
      if (song.id == null) {
        continue;
      }
      if (targets != null && !targets.contains(song.id)) {
        continue;
      }
      _songs[index] = _hydrateSong(song);
    }
  }

  void _assertTagNameAvailable(String name, {int? excludingId}) {
    final duplicate = _tags.any(
      (tag) =>
          tag.name.toLowerCase() == name.toLowerCase() && tag.id != excludingId,
    );
    if (duplicate) {
      throw StateError('Ya existe una etiqueta con ese nombre.');
    }
  }
}
