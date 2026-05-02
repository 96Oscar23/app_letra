import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state.dart';
import '../domain/song.dart';
import '../songs_controller.dart';
import 'widgets/song_card.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
    required this.controller,
    required this.onOpenSong,
  });

  final SongsController controller;
  final ValueChanged<Song> onOpenSong;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late final TextEditingController _searchController;

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  widget.controller.setQuery(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar por titulo, letra o autor',
                  prefixIcon: Icon(Icons.search),
                ),
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
                    onSelected: (_) {
                      widget.controller.setFilter(SongFilter.all);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Favoritos'),
                    selected: widget.controller.filter == SongFilter.favorites,
                    onSelected: (_) {
                      widget.controller.setFilter(SongFilter.favorites);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.controller.songs.isEmpty
                  ? const EmptyState(
                      icon: Icons.library_music_outlined,
                      title: 'Sin cantos visibles',
                      message:
                          'Agrega tu primer canto o ajusta la busqueda para ver resultados.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: widget.controller.songs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final song = widget.controller.songs[index];
                        return SongCard(
                          song: song,
                          onTap: () => widget.onOpenSong(song),
                          onFavoriteTap: () =>
                              widget.controller.toggleFavorite(song),
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
