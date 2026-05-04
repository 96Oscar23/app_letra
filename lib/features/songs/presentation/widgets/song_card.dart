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
    final preview = song.lyrics.trim().replaceAll('\n', ' ');

    return Card(
      key: ValueKey('song-card-${song.id ?? song.title}'),
      child: InkWell(
        key: ValueKey('song-card-tap-${song.id ?? song.title}'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF233A63),
                      Color(0xFF101A2A),
                    ],
                  ),
                  border: Border.all(color: AppColors.outline),
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            song.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onFavoriteTap,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          icon: Icon(
                            song.isFavorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: song.isFavorite
                                ? AppColors.tertiary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (song.author.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        song.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                    if (preview.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (song.baseKey.trim().isNotEmpty)
                          _MetaChip(label: song.baseKey),
                        if (song.genre.trim().isNotEmpty)
                          _MetaChip(label: song.genre),
                        if (song.author.trim().isNotEmpty)
                          _MetaChip(label: song.author),
                        if (song.category.trim().isNotEmpty)
                          _MetaChip(label: song.category),
                        ...song.tags
                            .take(2)
                            .map((tag) => _MetaChip(label: '#$tag')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
