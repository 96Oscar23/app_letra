import 'package:flutter/foundation.dart';

import 'data/song_repository.dart';
import 'domain/song.dart';
import 'domain/song_draft.dart';
import 'domain/song_library_filters.dart';
import 'domain/song_tag.dart';
import 'import/imported_file_storage.dart';

enum SongFilter { all, favorites, recent }

class SongsController extends ChangeNotifier {
  SongsController(
    this._repository, {
    ImportedFileStorage importedFileStorage = const ImportedFileStorage(),
  }) : _importedFileStorage = importedFileStorage;

  final SongRepository _repository;
  final ImportedFileStorage _importedFileStorage;

  static const suggestedCategories = [
    'Adoracion',
    'Alabanza',
    'Entrada',
    'Santa Cena',
  ];

  static const suggestedArtists = [
    'Marcos Witt',
    'Chris Tomlin',
    'Miel San Marcos',
    'Vineyard',
  ];

  static const suggestedGenres = [
    'Worship',
    'Balada',
    'Himno',
    'Pop',
  ];

  static const presetSeasonEventTags = [
    'Navidad',
    'Semana Santa',
    'Congreso',
    'Campamento',
    'Santa Cena',
    'Dia de las Madres',
  ];

  List<Song> _songs = const [];
  List<SongTag> _tags = const [];
  String _query = '';
  SongFilter _filter = SongFilter.all;
  SongLibraryFilters _libraryFilters = SongLibraryFilters.empty;
  bool _isLoading = false;
  int _totalSongCount = 0;
  int _favoriteSongCount = 0;
  int _recentSongCount = 0;

  List<Song> get songs => _songs;
  List<SongTag> get tags => _tags;
  String get query => _query;
  SongFilter get filter => _filter;
  SongLibraryFilters get libraryFilters => _libraryFilters;
  bool get isLoading => _isLoading;
  int get activeLibraryFilterCount => _libraryFilters.activeCount;
  bool get hasActiveLibraryFilters => !_libraryFilters.isEmpty;
  int get totalSongCount => _totalSongCount;
  int get favoriteSongCount => _favoriteSongCount;
  int get recentSongCount => _recentSongCount;

  List<String> get availableCategories =>
      _mergeFilterOptions(suggestedCategories, (song) => song.category);
  List<String> get availableArtists =>
      _mergeFilterOptions(suggestedArtists, (song) => song.author);
  List<String> get availableGenres =>
      _mergeFilterOptions(suggestedGenres, (song) => song.genre);
  List<String> get availableTagNames => _tags.map((tag) => tag.name).toList();
  List<SongTag> get customTags =>
      _tags.where((tag) => tag.isCustom).toList(growable: false);
  List<SongTag> get seasonEventTags =>
      _tags.where((tag) => tag.isSeasonEvent).toList(growable: false);

  Future<void> initialize() async {
    await _repository.seedInitialSongsIfEmpty();
    await _ensurePresetTags();
    await loadSongs();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    final filteredSongs = await _repository.fetchSongs(
      query: _query,
      favoritesOnly: _filter == SongFilter.favorites,
      recentOnly: _filter == SongFilter.recent,
      categories: _libraryFilters.categories,
      artists: _libraryFilters.artists,
      genres: _libraryFilters.genres,
      tags: _libraryFilters.tags,
    );
    final allSongs = await _repository.fetchSongs();
    final favoriteSongs = await _repository.fetchSongs(favoritesOnly: true);
    final recentSongs = await _repository.fetchSongs(recentOnly: true);
    final allTags = await _repository.fetchTags();

    _songs = filteredSongs;
    _totalSongCount = allSongs.length;
    _favoriteSongCount = favoriteSongs.length;
    _recentSongCount = recentSongs.length;
    _tags = allTags;

    _isLoading = false;
    notifyListeners();
  }

  Future<List<SongTag>> refreshTags() async {
    _tags = await _repository.fetchTags();
    notifyListeners();
    return _tags;
  }

  Future<void> setQuery(String value) async {
    _query = value;
    await loadSongs();
  }

  Future<void> setFilter(SongFilter value) async {
    _filter = value;
    await loadSongs();
  }

  Future<void> setLibraryFilters(SongLibraryFilters value) async {
    _libraryFilters = value;
    await loadSongs();
  }

  Future<void> clearLibraryFilters() async {
    _libraryFilters = SongLibraryFilters.empty;
    await loadSongs();
  }

  Future<void> removeLibraryFilterLabel(String key) async {
    _libraryFilters = _libraryFilters.removeByKey(key);
    await loadSongs();
  }

  Future<List<SongTag>> tagsForSong(int songId) =>
      _repository.fetchTagsForSong(songId);

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
          lastOpenedAt: null,
        ),
      );
      await _syncSongTagsFromDraft(newId, draft);
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
        lastOpenedAt: current.lastOpenedAt,
      ),
    );

    await _syncSongTagsFromDraft(id, draft);
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

  Future<void> markSongOpened(int id) async {
    final current = await _repository.findById(id);
    if (current == null) {
      return;
    }

    await _repository.updateSong(
      current.copyWith(lastOpenedAt: DateTime.now()),
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

  Future<SongTag> createTag(
    String name, {
    String type = SongTagTypes.custom,
  }) async {
    final created = await _createTagRaw(name, type: type);
    await loadSongs();
    return created;
  }

  Future<void> renameTag(SongTag tag, String nextName) async {
    await _repository.updateTag(
      tag.copyWith(
        name: nextName.trim(),
        updatedAt: DateTime.now(),
      ),
    );
    await loadSongs();
  }

  Future<void> deleteTag(SongTag tag) async {
    if (tag.id == null) {
      return;
    }
    await _repository.deleteTag(tag.id!);
    await loadSongs();
  }

  Future<void> setSongTags(int songId, List<SongTag> selectedTags) async {
    final validIds =
        selectedTags.map((tag) => tag.id).whereType<int>().toSet().toList();
    await _repository.replaceSongTags(songId, validIds);
    await loadSongs();
  }

  List<String> _mergeFilterOptions(
    List<String> suggested,
    String Function(Song song) selector,
  ) {
    final values = <String>{
      ...suggested.where((item) => item.trim().isNotEmpty),
      ..._songs
          .map(selector)
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    };

    final sorted = values.toList()..sort((a, b) => a.compareTo(b));
    return sorted;
  }

  Future<void> _ensurePresetTags() async {
    final existingTags = await _repository.fetchTags();
    final existingNames =
        existingTags.map((tag) => tag.name.trim().toLowerCase()).toSet();

    for (final label in presetSeasonEventTags) {
      if (existingNames.contains(label.toLowerCase())) {
        continue;
      }
      await _createTagRaw(label, type: SongTagTypes.seasonEvent);
    }
  }

  Future<SongTag> _createTagRaw(
    String name, {
    String type = SongTagTypes.custom,
  }) async {
    final normalized = name.trim();
    final now = DateTime.now();
    final tag = SongTag(
      name: normalized,
      type: type,
      createdAt: now,
      updatedAt: now,
    );
    final tagId = await _repository.createTag(tag);
    return tag.copyWith(id: tagId);
  }

  Future<void> _syncSongTagsFromDraft(int songId, SongDraft draft) async {
    final currentTags = await _repository.fetchTags();
    final byName = <String, SongTag>{
      for (final tag in currentTags) tag.name.trim().toLowerCase(): tag,
    };
    final selectedTags = <SongTag>[];

    for (final rawLabel in draft.tags) {
      final normalized = rawLabel.trim();
      if (normalized.isEmpty) {
        continue;
      }
      final existing = byName[normalized.toLowerCase()];
      if (existing != null) {
        selectedTags.add(existing);
        continue;
      }
      final created = await _createTagRaw(normalized);
      byName[normalized.toLowerCase()] = created;
      selectedTags.add(created);
    }

    final selectedIds =
        selectedTags.map((tag) => tag.id).whereType<int>().toSet().toList();
    await _repository.replaceSongTags(songId, selectedIds);
  }
}
