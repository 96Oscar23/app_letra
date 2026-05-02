import '../domain/song.dart';
import 'song_repository.dart';

class InMemorySongRepository implements SongRepository {
  InMemorySongRepository({
    List<Song>? initialSongs,
  }) : _songs = [...?initialSongs];

  final List<Song> _songs;
  int _nextId = 1;

  @override
  Future<int> createSong(Song song) async {
    final created = song.copyWith(id: _nextId++);
    _songs.add(created);
    return created.id!;
  }

  @override
  Future<void> deleteSong(int id) async {
    _songs.removeWhere((song) => song.id == id);
  }

  @override
  Future<Song?> findById(int id) async {
    for (final song in _songs) {
      if (song.id == id) {
        return song;
      }
    }
    return null;
  }

  @override
  Future<List<Song>> fetchSongs({
    String query = '',
    bool favoritesOnly = false,
  }) async {
    final normalizedQuery = query.toLowerCase().trim();
    return _songs.where((song) {
      final passesFavorite = !favoritesOnly || song.isFavorite;
      final haystack = [
        song.title,
        song.lyrics,
        song.author,
        song.category,
        song.notes,
        ...song.tags,
      ].join(' ').toLowerCase();
      final passesQuery =
          normalizedQuery.isEmpty || haystack.contains(normalizedQuery);
      return passesFavorite && passesQuery;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<void> seedInitialSongsIfEmpty() async {
    if (_songs.isNotEmpty) {
      return;
    }

    final now = DateTime(2026, 4, 1, 12);
    final seedSongs = [
      Song(
        id: _nextId++,
        title: 'Great Is Thy Faithfulness',
        lyrics: 'Great is Thy faithfulness...',
        baseKey: 'Eb',
        author: 'Thomas Chisholm',
        category: 'Adoracion',
        notes: 'Version congregacional.',
        capo: '',
        bpm: 72,
        tags: const ['clasico', 'adoracion'],
        status: SongStatuses.active,
        isFavorite: true,
        createdAt: now,
        updatedAt: now,
      ),
      Song(
        id: _nextId++,
        title: 'Celebracion de la Luz',
        lyrics: 'Eres la luz que alumbra...',
        baseKey: 'G',
        author: 'Ministerio local',
        category: 'Entrada',
        notes: '',
        capo: '',
        bpm: 68,
        tags: const ['entrada'],
        status: SongStatuses.active,
        isFavorite: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    _songs.addAll(seedSongs);
  }

  @override
  Future<void> updateSong(Song song) async {
    final index = _songs.indexWhere((item) => item.id == song.id);
    if (index != -1) {
      _songs[index] = song;
    }
  }
}
