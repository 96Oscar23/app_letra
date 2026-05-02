import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/song.dart';
import '../../import/song_import_result.dart';

class SongReferenceCard extends StatelessWidget {
  const SongReferenceCard({
    super.key,
    required this.song,
    required this.referenceExists,
    required this.onOpenReference,
    required this.onRemoveReference,
  });

  final Song song;
  final bool referenceExists;
  final VoidCallback onOpenReference;
  final VoidCallback onRemoveReference;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  (song.referenceFileType ?? '').toLowerCase() == 'pdf'
                      ? Icons.picture_as_pdf_outlined
                      : Icons.attach_file_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Archivo de referencia',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.referenceFileName ?? 'Referencia guardada',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if ((song.referenceFileType ?? '').isNotEmpty)
                _Tag(label: song.referenceFileType!),
              if ((song.referenceFileExtension ?? '').isNotEmpty)
                _Tag(label: song.referenceFileExtension!.toUpperCase()),
              _Tag(label: formatFileSize(song.referenceFileSizeBytes)),
              _Tag(
                label: referenceExists ? 'Disponible' : 'No encontrado',
                color: referenceExists ? AppColors.primary : AppColors.tertiary,
              ),
              if (song.referenceImportedAt != null)
                _Tag(
                  label: _formatImportedAt(song.referenceImportedAt!),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onOpenReference,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Ver referencia'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRemoveReference,
                  icon: const Icon(Icons.link_off_rounded),
                  label: const Text('Quitar referencia'),
                ),
              ),
            ],
          ),
          if (!referenceExists) ...[
            const SizedBox(height: 12),
            const Text(
              'El archivo asociado ya no existe. Puedes quitar la referencia y conservar el canto.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  String _formatImportedAt(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return 'Importado $day/$month/$year';
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    this.color,
  });

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.surfaceSoft).withValues(
          alpha: color == null ? 1 : 0.18,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
