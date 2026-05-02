import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/song.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.song,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Song song;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.music_note, color: AppColors.primary),
        ),
        title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(label: song.baseKey),
              if (song.category.trim().isNotEmpty)
                _MetaChip(label: song.category),
              if (song.author.trim().isNotEmpty) _MetaChip(label: song.author),
            ],
          ),
        ),
        trailing: IconButton(
          onPressed: onFavoriteTap,
          icon: Icon(
            song.isFavorite ? Icons.favorite : Icons.favorite_border,
            color:
                song.isFavorite ? AppColors.tertiary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
