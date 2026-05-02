import '../domain/song.dart';

abstract class SongRepository {
  Future<void> seedInitialSongsIfEmpty();
  Future<List<Song>> fetchSongs({
    String query = '',
    bool favoritesOnly = false,
  });
  Future<Song?> findById(int id);
  Future<int> createSong(Song song);
  Future<void> updateSong(Song song);
  Future<void> deleteSong(int id);
}
