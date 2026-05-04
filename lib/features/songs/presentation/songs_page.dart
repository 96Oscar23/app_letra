import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../domain/song.dart';
import '../domain/song_library_filters.dart';
import '../songs_controller.dart';
import 'song_filters_sheet.dart';
import 'widgets/song_slidable_tile.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
    required this.controller,
    required this.onOpenSong,
    required this.onEditSong,
  });

  final SongsController controller;
  final ValueChanged<Song> onOpenSong;
  final Future<bool?> Function(Song song) onEditSong;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late final TextEditingController _searchController;

  String _resultLabel(int count) {
    if (count == 1) {
      return '1 canto';
    }
    return '$count cantos';
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.controller.query);
  }

  @override
  void didUpdateWidget(covariant SongsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_searchController.text != widget.controller.query) {
      _searchController.value = TextEditingValue(
        text: widget.controller.query,
        selection: TextSelection.collapsed(
          offset: widget.controller.query.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.controller.setQuery('');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleFavoriteToggle(Song song) async {
    await widget.controller.toggleFavorite(song);
    if (!mounted) {
      return;
    }
    _showMessage(
      song.isFavorite
          ? 'Canto quitado de favoritos'
          : 'Canto marcado como favorito',
    );
  }

  Future<void> _handleEditSong(Song song) async {
    final changed = await widget.onEditSong(song);
    if (!mounted || changed != true) {
      return;
    }
    _showMessage('Cambios guardados');
  }

  Future<void> _handleDeleteSong(Song song) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar canto'),
        content: Text(
          'Se eliminara "${song.title}". Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirmed != true || song.id == null) {
      return;
    }

    await widget.controller.deleteSong(song.id!);
    if (!mounted) {
      return;
    }
    _showMessage('Canto eliminado');
  }

  Future<void> _resetToAll() async {
    await widget.controller.setFilter(SongFilter.all);
    if (_searchController.text.trim().isNotEmpty) {
      _clearSearch();
      return;
    }
    if (widget.controller.hasActiveLibraryFilters) {
      await widget.controller.clearLibraryFilters();
    }
  }

  Widget _buildEmptyState() {
    final hasSearch = _searchController.text.trim().isNotEmpty;
    final hasFilters = widget.controller.hasActiveLibraryFilters;

    if (!hasSearch && !hasFilters) {
      if (widget.controller.filter == SongFilter.favorites) {
        return EmptyState(
          icon: Icons.star_outline_rounded,
          title: 'Aun no tienes favoritos',
          message:
              'Marca tus cantos mas usados para encontrarlos rapidamente aqui.',
          action: FilledButton.icon(
            onPressed: _resetToAll,
            icon: const Icon(Icons.library_music_rounded),
            label: const Text('Explorar biblioteca'),
          ),
        );
      }

      if (widget.controller.filter == SongFilter.recent) {
        return EmptyState(
          icon: Icons.history_rounded,
          title: 'Aun no hay cantos recientes',
          message:
              'Abre un canto desde tu biblioteca y aparecera aqui automaticamente.',
          action: FilledButton.icon(
            onPressed: _resetToAll,
            icon: const Icon(Icons.library_music_rounded),
            label: const Text('Explorar biblioteca'),
          ),
        );
      }
    }

    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No encontramos cantos',
      message: 'Intenta cambiar la busqueda o limpiar algunos filtros.',
      action: hasSearch || hasFilters
          ? FilledButton.icon(
              onPressed: _resetToAll,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                hasSearch && hasFilters
                    ? 'Limpiar busqueda y filtros'
                    : hasFilters
                        ? 'Limpiar filtros'
                        : 'Limpiar busqueda',
              ),
            )
          : null,
    );
  }

  Future<void> _openFilters() async {
    final nextFilters = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.88,
        child: SongFiltersSheet(
          initialFilters: widget.controller.libraryFilters,
          availableCategories: widget.controller.availableCategories,
          availableArtists: widget.controller.availableArtists,
          availableGenres: widget.controller.availableGenres,
          availableTags: widget.controller.availableTagNames,
          searchQuery: widget.controller.query,
        ),
      ),
    );

    if (nextFilters is! SongLibraryFilters) {
      return;
    }

    await widget.controller.setLibraryFilters(nextFilters);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: widget.controller.setQuery,
                        decoration: InputDecoration(
                          hintText: 'Buscar por titulo o letra',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.trim().isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Limpiar busqueda',
                                  onPressed: _clearSearch,
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _openFilters,
                      borderRadius: BorderRadius.circular(14),
                      child: Ink(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.controller.hasActiveLibraryFilters
                              ? AppColors.primary.withValues(alpha: 0.16)
                              : AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: widget.controller.hasActiveLibraryFilters
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            if (widget.controller.activeLibraryFilterCount > 0)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${widget.controller.activeLibraryFilterCount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Resultados',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    _resultLabel(widget.controller.songs.length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.swipe_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Desliza a la izquierda o derecha para administrar cantos.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.controller.hasActiveLibraryFilters)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: widget.controller.libraryFilters.activeChips
                      .map(
                        (chip) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InputChip(
                            label: Text(chip.label),
                            selected: true,
                            onDeleted: () {
                              widget.controller
                                  .removeLibraryFilterLabel(chip.key);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: widget.controller.filter == SongFilter.all,
                    onSelected: (_) =>
                        widget.controller.setFilter(SongFilter.all),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Favoritos'),
                    selected: widget.controller.filter == SongFilter.favorites,
                    onSelected: (_) =>
                        widget.controller.setFilter(SongFilter.favorites),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Recientes'),
                    selected: widget.controller.filter == SongFilter.recent,
                    onSelected: (_) =>
                        widget.controller.setFilter(SongFilter.recent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.controller.songs.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: widget.controller.songs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final song = widget.controller.songs[index];
                        return SongSlidableTile(
                          song: song,
                          onTap: () => widget.onOpenSong(song),
                          onEdit: () => _handleEditSong(song),
                          onFavoriteTap: () => _handleFavoriteToggle(song),
                          onDeleteTap: () => _handleDeleteSong(song),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
