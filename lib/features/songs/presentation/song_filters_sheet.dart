import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/song_library_filters.dart';

class SongFiltersSheet extends StatefulWidget {
  const SongFiltersSheet({
    super.key,
    required this.initialFilters,
    required this.availableCategories,
    required this.availableArtists,
    required this.availableGenres,
    required this.availableTags,
    required this.searchQuery,
  });

  final SongLibraryFilters initialFilters;
  final List<String> availableCategories;
  final List<String> availableArtists;
  final List<String> availableGenres;
  final List<String> availableTags;
  final String searchQuery;

  @override
  State<SongFiltersSheet> createState() => _SongFiltersSheetState();
}

class _SongFiltersSheetState extends State<SongFiltersSheet> {
  late Set<String> _categories;
  late Set<String> _artists;
  late Set<String> _genres;
  late Set<String> _tags;

  @override
  void initState() {
    super.initState();
    _categories = {...widget.initialFilters.categories};
    _artists = {...widget.initialFilters.artists};
    _genres = {...widget.initialFilters.genres};
    _tags = {...widget.initialFilters.tags};
  }

  int get _activeCount =>
      _categories.length + _artists.length + _genres.length + _tags.length;

  void _toggle(Set<String> target, String value) {
    setState(() {
      if (target.contains(value)) {
        target.remove(value);
      } else {
        target.add(value);
      }
    });
  }

  void _clear() {
    setState(() {
      _categories.clear();
      _artists.clear();
      _genres.clear();
      _tags.clear();
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      SongLibraryFilters(
        categories: _categories,
        artists: _artists,
        genres: _genres,
        tags: _tags,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111925),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 52,
                  child: Divider(thickness: 4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (_activeCount > 0)
                    Text(
                      _activeCount == 1
                          ? '1 filtro activo'
                          : '$_activeCount filtros activos',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                ],
              ),
              if (widget.searchQuery.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Buscar: "${widget.searchQuery.trim()}"',
                          style:
                              const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FilterSection(
                        title: 'Categoria',
                        options: widget.availableCategories,
                        selected: _categories,
                        onToggle: (value) => _toggle(_categories, value),
                      ),
                      const SizedBox(height: 16),
                      _FilterSection(
                        title: 'Artista',
                        options: widget.availableArtists,
                        selected: _artists,
                        onToggle: (value) => _toggle(_artists, value),
                      ),
                      const SizedBox(height: 16),
                      _FilterSection(
                        title: 'Genero musical',
                        options: widget.availableGenres,
                        selected: _genres,
                        onToggle: (value) => _toggle(_genres, value),
                      ),
                      const SizedBox(height: 16),
                      _FilterSection(
                        title: 'Etiquetas',
                        options: widget.availableTags,
                        selected: _tags,
                        onToggle: (value) => _toggle(_tags, value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_activeCount > 0)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _clear,
                    child: const Text('Limpiar filtros'),
                  ),
                ),
              if (_activeCount > 0) const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _apply,
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: selected.contains(option),
                  onSelected: (_) => onToggle(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
