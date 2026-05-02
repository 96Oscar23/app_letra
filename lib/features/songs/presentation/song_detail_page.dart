import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../settings/settings_controller.dart';
import '../domain/song.dart';
import '../import/song_import_result.dart';
import '../songs_controller.dart';
import '../utils/song_plain_text_formatter.dart';
import 'song_form_page.dart';

enum _SongDetailAction {
  copyLyrics,
  copyFullSong,
  exportPlainText,
}

class SongDetailPage extends StatefulWidget {
  const SongDetailPage({
    super.key,
    required this.songId,
    required this.songsController,
    required this.settingsController,
  });

  final int songId;
  final SongsController songsController;
  final SettingsController settingsController;

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  Song? _song;

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    final song = await widget.songsController.findById(widget.songId);
    if (!mounted) return;
    setState(() => _song = song);
  }

  Future<void> _editSong() async {
    if (_song == null) return;
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SongFormPage(
          controller: widget.songsController,
          song: _song,
          mode: SongFormMode.complete,
        ),
      ),
    );
    if (changed == true) {
      await _loadSong();
    }
  }

  Future<void> _deleteSong() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar canto'),
        content: const Text('Esta accion no se puede deshacer.'),
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

    if (confirmed != true || _song?.id == null) return;
    await widget.songsController.deleteSong(_song!.id!);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _handleAction(_SongDetailAction action) async {
    final song = _song;
    if (song == null) return;

    switch (action) {
      case _SongDetailAction.copyLyrics:
        await Clipboard.setData(
          ClipboardData(text: SongPlainTextFormatter.lyricsOnly(song)),
        );
        _showMessage('Letra copiada al portapapeles.');
        break;
      case _SongDetailAction.copyFullSong:
        await Clipboard.setData(
          ClipboardData(text: SongPlainTextFormatter.fullSong(song)),
        );
        _showMessage('Canto completo copiado al portapapeles.');
        break;
      case _SongDetailAction.exportPlainText:
        await _exportAsText(song);
        break;
    }
  }

  Future<void> _exportAsText(Song song) async {
    final text = SongPlainTextFormatter.fullSong(song);
    final fileName = _safeFileName(song.title);
    final exportedPath = await FilePicker.saveFile(
      dialogTitle: 'Exportar canto como texto',
      fileName: '$fileName.txt',
      type: FileType.custom,
      allowedExtensions: ['txt'],
      bytes: Uint8List.fromList(utf8.encode(text)),
    );

    if (exportedPath != null) {
      if (!mounted) return;
      _showMessage('Archivo exportado en:\n$exportedPath');
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, '$fileName.txt'));
    await file.writeAsString(text);

    if (!mounted) return;
    _showMessage('Archivo exportado en:\n${file.path}');
  }

  String _safeFileName(String title) {
    final normalized = title.trim().toLowerCase().replaceAll(' ', '_');
    final safe = normalized.replaceAll(RegExp(r'[^a-z0-9_]+'), '');
    return safe.isEmpty ? 'canto_exportado' : safe;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final song = _song;
    final fontScale = widget.settingsController.settings.fontScale;

    if (song == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de canto'),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.songsController.toggleFavorite(song);
              await _loadSong();
            },
            icon: Icon(
              song.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: song.isFavorite ? AppColors.tertiary : null,
            ),
          ),
          IconButton(
              onPressed: _editSong, icon: const Icon(Icons.edit_outlined)),
          PopupMenuButton<_SongDetailAction>(
            onSelected: _handleAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _SongDetailAction.copyLyrics,
                child: Text('Copiar letra'),
              ),
              PopupMenuItem(
                value: _SongDetailAction.copyFullSong,
                child: Text('Copiar canto completo'),
              ),
              PopupMenuItem(
                value: _SongDetailAction.exportPlainText,
                child: Text('Exportar como texto simple'),
              ),
            ],
          ),
          IconButton(
            onPressed: _deleteSong,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (song.baseKey.isNotEmpty) _Tag(label: song.baseKey),
                    if (song.author.isNotEmpty) _Tag(label: song.author),
                    if (song.category.isNotEmpty) _Tag(label: song.category),
                    if (song.capo.isNotEmpty) _Tag(label: 'Capo ${song.capo}'),
                    if (song.bpm != null) _Tag(label: '${song.bpm} BPM'),
                    if (song.status.isNotEmpty) _Tag(label: song.status),
                    ...song.tags.map((tag) => _Tag(label: '#$tag')),
                  ],
                ),
                if (song.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    song.notes,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (song.hasReference) ...[
            const SizedBox(height: 16),
            AppCard(
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
                      _Tag(label: formatFileSize(song.referenceFileSizeBytes)),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          AppCard(
            child: Text(
              song.lyrics,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18 * fontScale,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
