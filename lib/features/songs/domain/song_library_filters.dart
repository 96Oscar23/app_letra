class SongLibraryFilters {
  const SongLibraryFilters({
    this.categories = const {},
    this.artists = const {},
    this.genres = const {},
    this.tags = const {},
  });

  final Set<String> categories;
  final Set<String> artists;
  final Set<String> genres;
  final Set<String> tags;

  static const empty = SongLibraryFilters();

  bool get isEmpty =>
      categories.isEmpty && artists.isEmpty && genres.isEmpty && tags.isEmpty;

  int get activeCount =>
      categories.length + artists.length + genres.length + tags.length;

  List<SongLibraryFilterChip> get activeChips => [
        ...categories.map(
          (value) => SongLibraryFilterChip(
            key: 'category:$value',
            label: value,
          ),
        ),
        ...artists.map(
          (value) => SongLibraryFilterChip(
            key: 'artist:$value',
            label: value,
          ),
        ),
        ...genres.map(
          (value) => SongLibraryFilterChip(
            key: 'genre:$value',
            label: value,
          ),
        ),
        ...tags.map(
          (value) => SongLibraryFilterChip(
            key: 'tag:$value',
            label: value,
          ),
        ),
      ];

  SongLibraryFilters copyWith({
    Set<String>? categories,
    Set<String>? artists,
    Set<String>? genres,
    Set<String>? tags,
  }) {
    return SongLibraryFilters(
      categories: categories ?? this.categories,
      artists: artists ?? this.artists,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
    );
  }

  SongLibraryFilters removeByKey(String key) {
    final nextCategories = {...categories};
    final nextArtists = {...artists};
    final nextGenres = {...genres};
    final nextTags = {...tags};

    if (key.startsWith('category:')) {
      nextCategories.remove(key.substring('category:'.length));
    } else if (key.startsWith('artist:')) {
      nextArtists.remove(key.substring('artist:'.length));
    } else if (key.startsWith('genre:')) {
      nextGenres.remove(key.substring('genre:'.length));
    } else if (key.startsWith('tag:')) {
      nextTags.remove(key.substring('tag:'.length));
    }

    return SongLibraryFilters(
      categories: nextCategories,
      artists: nextArtists,
      genres: nextGenres,
      tags: nextTags,
    );
  }
}

class SongLibraryFilterChip {
  const SongLibraryFilterChip({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}
