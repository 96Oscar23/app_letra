import '../domain/song.dart';
import '../domain/song_tag.dart';

abstract class SongRepository {
  Future<void> seedInitialSongsIfEmpty();
  Future<List<Song>> fetchSongs({
    String query = '',
    bool favoritesOnly = false,
    bool recentOnly = false,
    Set<String> categories = const {},
    Set<String> artists = const {},
    Set<String> genres = const {},
    Set<String> tags = const {},
  });
  Future<Song?> findById(int id);
  Future<int> createSong(Song song);
  Future<void> updateSong(Song song);
  Future<void> deleteSong(int id);
  Future<List<SongTag>> fetchTags();
  Future<List<SongTag>> fetchTagsForSong(int songId);
  Future<int> createTag(SongTag tag);
  Future<void> updateTag(SongTag tag);
  Future<void> deleteTag(int id);
  Future<void> replaceSongTags(int songId, List<int> tagIds);
}
