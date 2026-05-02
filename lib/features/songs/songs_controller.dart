import 'package:flutter/foundation.dart';

import 'data/song_repository.dart';
import 'domain/song_draft.dart';
import 'domain/song.dart';
import 'import/imported_file_storage.dart';

enum SongFilter { all, favorites }

class SongsController extends ChangeNotifier {
  SongsController(
    this._repository, {
    ImportedFileStorage importedFileStorage = const ImportedFileStorage(),
  }) : _importedFileStorage = importedFileStorage;

  final SongRepository _repository;
  final ImportedFileStorage _importedFileStorage;

  List<Song> _songs = const [];
  String _query = '';
  SongFilter _filter = SongFilter.all;
  bool _isLoading = false;

  List<Song> get songs => _songs;
  String get query => _query;
  SongFilter get filter => _filter;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await _repository.seedInitialSongsIfEmpty();
    await loadSongs();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    _songs = await _repository.fetchSongs(
      query: _query,
      favoritesOnly: _filter == SongFilter.favorites,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setQuery(String value) async {
    _query = value;
    await loadSongs();
  }

  Future<void> setFilter(SongFilter value) async {
    _filter = value;
    await loadSongs();
  }

  Future<Song?> findById(int id) => _repository.findById(id);

  Future<int> saveDraft({
    int? id,
    required SongDraft draft,
    bool isFavorite = false,
  }) async {
    final now = DateTime.now();

    if (id == null) {
      final newId = await _repository.createSong(
        draft.toSong(
          isFavorite: isFavorite,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await loadSongs();
      return newId;
    }

    final current = await _repository.findById(id);
    if (current == null) {
      throw StateError('No se encontro el canto con id $id');
    }

    await _repository.updateSong(
      draft.toSong(
        id: current.id,
        isFavorite: isFavorite,
        createdAt: current.createdAt,
        updatedAt: now,
      ),
    );

    await loadSongs();
    return id;
  }

  Future<void> toggleFavorite(Song song) async {
    await _repository.updateSong(
      song.copyWith(
        isFavorite: !song.isFavorite,
        updatedAt: DateTime.now(),
      ),
    );
    await loadSongs();
  }

  Future<void> deleteSong(int id) async {
    final current = await _repository.findById(id);
    await _importedFileStorage.deleteIfExists(current?.referenceFilePath);
    await _repository.deleteSong(id);
    await loadSongs();
  }

  Future<void> removeReference(Song song) async {
    await _importedFileStorage.deleteIfExists(song.referenceFilePath);
    await _repository.updateSong(
      song.copyWith(
        referenceFilePath: '',
        referenceFileName: '',
        referenceFileType: '',
        referenceFileExtension: '',
        referenceFileSizeBytes: null,
        referenceImportedAt: null,
        updatedAt: DateTime.now(),
      ),
    );
    await loadSongs();
  }
}
