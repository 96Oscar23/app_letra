import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/song.dart';
import 'song_card.dart';

class SongSlidableTile extends StatelessWidget {
  const SongSlidableTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.onEdit,
    required this.onFavoriteTap,
    required this.onDeleteTap,
  });

  final Song song;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey('song-slidable-${song.id ?? song.title}'),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.50,
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit_outlined,
            label: 'Editar',
            borderRadius: BorderRadius.circular(20),
          ),
          SlidableAction(
            onPressed: (_) => onFavoriteTap(),
            backgroundColor: const Color(0xFFD6A623),
            foregroundColor: Colors.white,
            icon: song.isFavorite
                ? Icons.star_outline_rounded
                : Icons.star_rounded,
            label: song.isFavorite ? 'Quitar favorito' : 'Favorito',
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onDeleteTap(),
            backgroundColor: const Color(0xFFB93A3A),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Borrar',
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      child: SongCard(
        song: song,
        onTap: onTap,
        onFavoriteTap: onFavoriteTap,
      ),
    );
  }
}
