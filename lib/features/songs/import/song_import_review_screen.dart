import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../domain/song_draft.dart';
import '../songs_controller.dart';
import 'song_import_result.dart';
import 'song_reference_storage_service.dart';

class SongImportReviewScreen extends StatefulWidget {
  const SongImportReviewScreen({
    super.key,
    required this.controller,
    required this.importResult,
    this.initialDraft,
    this.helperMessage,
    this.referenceStorageService = const SongReferenceStorageService(),
  });

  final SongsController controller;
  final SongImportResult importResult;
  final SongDraft? initialDraft;
  final String? helperMessage;
  final SongReferenceStorageService referenceStorageService;

  @override
  State<SongImportReviewScreen> createState() => _SongImportReviewScreenState();
}

class _SongImportReviewScreenState extends State<SongImportReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _toneController;
  late final TextEditingController _notesController;
  late final TextEditingController _lyricsController;

  bool _saveReference = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initialDraft = widget.initialDraft ?? const SongDraft();
    _titleController = TextEditingController(
      text: initialDraft.title.trim().isNotEmpty
          ? initialDraft.title
          : widget.importResult.suggestedTitle,
    );
    _authorController = TextEditingController(text: initialDraft.author);
    _toneController = TextEditingController(text: initialDraft.baseKey);
    _notesController = TextEditingController(text: initialDraft.notes);
    _lyricsController = TextEditingController(text: initialDraft.lyrics);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _toneController.dispose();
    _notesController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  Future<void> _saveSong() async {
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final lyrics = _lyricsController.text.trim();

    if (title.isEmpty) {
      _showMessage('Agrega un titulo antes de guardar.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showMessage('Revisa los campos obligatorios antes de continuar.');
      return;
    }

    if (lyrics.isEmpty && !_saveReference) {
      _showMessage(
        'Agrega la letra o activa "Guardar archivo como referencia".',
      );
      return;
    }

    if (lyrics.isEmpty && _saveReference) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Guardar solo referencia'),
          content: const Text(
            'No hay letra capturada todavia. Se guardara el canto con el archivo de referencia para completarlo despues.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }
    }

    setState(() => _saving = true);

    try {
      var storedResult = widget.importResult;
      if (_saveReference) {
        storedResult = await widget.referenceStorageService
            .persistReference(widget.importResult);
      }

      final draft = SongDraft(
        title: title,
        lyrics: lyrics,
        baseKey: _toneController.text.trim(),
        author: _authorController.text.trim(),
        notes: _notesController.text.trim(),
        referenceFilePath: _saveReference ? storedResult.localPath : null,
        referenceFileName: _saveReference ? storedResult.fileName : null,
        referenceFileType: _saveReference ? storedResult.fileTypeLabel : null,
        referenceFileExtension: _saveReference
            ? path.extension(storedResult.fileName).replaceFirst('.', '')
            : null,
        referenceFileSizeBytes: _saveReference ? storedResult.sizeBytes : null,
        referenceImportedAt: _saveReference ? DateTime.now() : null,
      );

      await widget.controller.saveDraft(draft: draft);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } on SongImportException catch (error) {
      _showMessage(error.message);
      if (mounted) {
        setState(() => _saving = false);
      }
    } catch (_) {
      _showMessage('No se pudo crear el canto con el archivo seleccionado.');
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) {
      return;
    }

    final text = data?.text?.trim() ?? '';
    if (text.isEmpty) {
      _showMessage('No hay texto disponible en el portapapeles.');
      return;
    }

    setState(() {
      _lyricsController.text = text;
      _lyricsController.selection = TextSelection.collapsed(
        offset: _lyricsController.text.length,
      );
    });

    _showMessage('Texto pegado en la letra para que puedas revisarlo.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final importResult = widget.importResult;
    final helperMessage = widget.helperMessage ??
        (importResult.supportsOcr
            ? 'Si el OCR no detecta todo correctamente, corrige aqui antes de guardar.'
            : 'La extraccion automatica todavia no esta activa para este archivo. Completa los campos manualmente o guarda la referencia.');
    final helperColor = _lyricsController.text.trim().isNotEmpty
        ? AppColors.primary
        : AppColors.tertiary;

    return Scaffold(
      appBar: AppBar(title: const Text('Revisar contenido')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          importResult.supportsPreview
                              ? Icons.image_outlined
                              : Icons.picture_as_pdf_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              importResult.fileName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${importResult.fileTypeLabel} - ${formatFileSize(importResult.sizeBytes)}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (importResult.supportsPreview) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: Image.file(
                          File(importResult.localPath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceSoft,
                            alignment: Alignment.center,
                            child: const Text(
                              'No se pudo mostrar la vista previa.',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: helperColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
              ),
              child: Text(helperMessage),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titulo'),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'El titulo es obligatorio'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Autor'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _toneController,
              decoration: const InputDecoration(
                labelText: 'Tono base',
                hintText: 'Ej. G, C#m, Bb',
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notas'),
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lyricsController,
              decoration: InputDecoration(
                labelText: 'Letra',
                helperText: _saveReference
                    ? 'Puedes dejarla vacia solo si confirmas guardar la referencia.'
                    : 'La letra es obligatoria para guardar.',
                hintText:
                    'Pega o escribe aqui la letra mientras llega la extraccion automatica.',
              ),
              minLines: 10,
              maxLines: 16,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pasteFromClipboard,
              icon: const Icon(Icons.content_paste_go),
              label: const Text('Pegar texto'),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Guardar archivo como referencia'),
              subtitle: const Text(
                'Se copiara el archivo dentro de la app para conservarlo con el canto.',
              ),
              value: _saveReference,
              onChanged: _saving
                  ? null
                  : (value) {
                      setState(() => _saveReference = value);
                    },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _saveSong,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Guardando...' : 'Crear canto'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _saving ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
