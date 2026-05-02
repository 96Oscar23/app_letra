import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

enum SongCreationAction {
  quick,
  complete,
  pasteText,
  importTxt,
  importPdf,
  importImage,
  takePhoto,
}

class SongCreationOptionsSheet extends StatelessWidget {
  const SongCreationOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1B2431),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: SizedBox(
                    width: 52,
                    child: Divider(thickness: 4),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Agregar contenido',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Elige como quieres agregar tu cancion o archivo base.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                _OptionTile(
                  icon: Icons.flash_on_rounded,
                  color: AppColors.primary,
                  title: 'Nuevo canto rapido',
                  subtitle:
                      'Guarda titulo, letra, tono y notas en pocos pasos.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.quick),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.edit_note_rounded,
                  color: AppColors.secondary,
                  title: 'Nuevo canto completo',
                  subtitle:
                      'Agrega autor, tono, capo, BPM, etiquetas y estado del canto.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.complete),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.content_paste_rounded,
                  color: AppColors.tertiary,
                  title: 'Pegar texto',
                  subtitle:
                      'Pega una letra completa y revisala antes de guardar.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.pasteText),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.description_outlined,
                  color: AppColors.primary,
                  title: 'Importar archivo .txt',
                  subtitle:
                      'Carga una letra desde un archivo de texto y revisa el resultado.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.importTxt),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.picture_as_pdf_outlined,
                  color: AppColors.secondary,
                  title: 'Importar PDF',
                  subtitle:
                      'Selecciona un PDF y revisa manualmente el contenido antes de crear el canto.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.importPdf),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.image_outlined,
                  color: AppColors.tertiary,
                  title: 'Importar imagen',
                  subtitle:
                      'Carga una imagen desde la galeria y pasa a una revision basica.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.importImage),
                ),
                const SizedBox(height: 10),
                _OptionTile(
                  icon: Icons.photo_camera_outlined,
                  color: AppColors.primary,
                  title: 'Tomar foto',
                  subtitle:
                      'Abre la camara, captura una foto y usala como base del canto.',
                  onTap: () =>
                      Navigator.of(context).pop(SongCreationAction.takePhoto),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
