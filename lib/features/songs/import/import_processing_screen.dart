import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../domain/song_draft.dart';
import '../songs_controller.dart';
import '../utils/song_text_parser.dart';
import 'song_image_text_extractor.dart';
import 'song_import_result.dart';
import 'song_import_review_screen.dart';
import 'song_ocr_service.dart';

typedef SongImportProcessor = Future<SongImportProcessingPayload> Function(
  SongImportResult importResult, {
  void Function(String status)? onStatusChanged,
});

class SongImportProcessingPayload {
  const SongImportProcessingPayload({
    required this.initialDraft,
    required this.helperMessage,
  });

  final SongDraft initialDraft;
  final String helperMessage;
}

class ImportProcessingScreen extends StatefulWidget {
  const ImportProcessingScreen({
    super.key,
    required this.controller,
    required this.initialImportResult,
    required this.retryLoader,
    required this.retryActionLabel,
    required this.processor,
    required this.initialStatusLabel,
    required this.noTextTitle,
    required this.noTextMessage,
    required this.errorTitle,
    required this.fallbackErrorMessage,
    required this.retrySelectionErrorMessage,
  });

  factory ImportProcessingScreen.forImage({
    Key? key,
    required SongsController controller,
    required SongImportResult initialImportResult,
    required Future<SongImportResult?> Function() retryLoader,
    required String retryActionLabel,
    SongImageTextExtractor textExtractor = const SongImageTextExtractor(
      MlKitSongOcrService(),
    ),
  }) {
    return ImportProcessingScreen(
      key: key,
      controller: controller,
      initialImportResult: initialImportResult,
      retryLoader: retryLoader,
      retryActionLabel: retryActionLabel,
      initialStatusLabel: 'Analizando imagen...',
      noTextTitle: 'No se pudo extraer texto',
      noTextMessage:
          'Prueba con otra imagen mas clara, pega texto desde el portapapeles o continua a la revision manual.',
      errorTitle: 'No se pudo procesar la imagen',
      fallbackErrorMessage:
          'Ocurrio un problema al ejecutar el OCR sobre la imagen seleccionada.',
      retrySelectionErrorMessage:
          'No se pudo volver a cargar la imagen seleccionada.',
      processor: (
        SongImportResult importResult, {
        void Function(String status)? onStatusChanged,
      }) async {
        final extraction = await textExtractor.extractText(
          importResult,
          onStageChanged: (stage) {
            final status = switch (stage) {
              SongOcrStage.analyzingImage => 'Analizando imagen...',
              SongOcrStage.extractingText => 'Extrayendo texto...',
            };
            onStatusChanged?.call(status);
          },
        );

        final parsedDraft = SongTextParser.parse(extraction.normalizedText);
        return SongImportProcessingPayload(
          initialDraft: parsedDraft.copyWith(lyrics: extraction.normalizedText),
          helperMessage:
              'Se detecto texto en la imagen. Revisa y corrige antes de guardar.',
        );
      },
    );
  }

  final SongsController controller;
  final SongImportResult initialImportResult;
  final Future<SongImportResult?> Function() retryLoader;
  final String retryActionLabel;
  final SongImportProcessor processor;
  final String initialStatusLabel;
  final String noTextTitle;
  final String noTextMessage;
  final String errorTitle;
  final String fallbackErrorMessage;
  final String retrySelectionErrorMessage;

  @override
  State<ImportProcessingScreen> createState() => _ImportProcessingScreenState();
}

enum _ProcessingStatus {
  processing,
  noText,
  error,
}

class _ImportProcessingScreenState extends State<ImportProcessingScreen> {
  late SongImportResult _currentImportResult;
  _ProcessingStatus _status = _ProcessingStatus.processing;
  late String _currentStatusLabel;
  String? _errorMessage;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _currentImportResult = widget.initialImportResult;
    _currentStatusLabel = widget.initialStatusLabel;
    _processImport();
  }

  Future<void> _processImport() async {
    setState(() {
      _busy = true;
      _status = _ProcessingStatus.processing;
      _currentStatusLabel = widget.initialStatusLabel;
      _errorMessage = null;
    });

    try {
      final payload = await widget.processor(
        _currentImportResult,
        onStatusChanged: (status) {
          if (!mounted) {
            return;
          }
          setState(() => _currentStatusLabel = status);
        },
      );

      if (!mounted) {
        return;
      }

      if (payload.initialDraft.lyrics.trim().isEmpty) {
        setState(() {
          _busy = false;
          _status = _ProcessingStatus.noText;
        });
        return;
      }

      _openReview(
        initialDraft: payload.initialDraft,
        helperMessage: payload.helperMessage,
      );
    } on SongImportException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _status = _ProcessingStatus.error;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _status = _ProcessingStatus.error;
        _errorMessage = widget.fallbackErrorMessage;
      });
    }
  }

  Future<void> _retrySelection() async {
    setState(() => _busy = true);

    try {
      final nextImportResult = await widget.retryLoader();
      if (!mounted) {
        return;
      }

      if (nextImportResult == null) {
        setState(() => _busy = false);
        _showMessage('Seleccion cancelada.');
        return;
      }

      _currentImportResult = nextImportResult;
      await _processImport();
    } on SongImportException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _status = _ProcessingStatus.error;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _status = _ProcessingStatus.error;
        _errorMessage = widget.retrySelectionErrorMessage;
      });
    }
  }

  Future<void> _openReviewWithClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) {
      return;
    }

    final clipboardText = data?.text?.trim() ?? '';
    if (clipboardText.isEmpty) {
      _showMessage('No hay texto disponible en el portapapeles.');
      return;
    }

    final parsedDraft = SongTextParser.parse(clipboardText);
    _openReview(
      initialDraft: parsedDraft.copyWith(lyrics: clipboardText),
      helperMessage:
          'Se pego texto desde el portapapeles. Revisa y corrige antes de guardar.',
    );
  }

  void _continueWithoutText() {
    _openReview(
      initialDraft: const SongDraft(),
      helperMessage:
          'No se detecto texto util. Puedes escribir manualmente, pegar texto o guardar solo la referencia.',
    );
  }

  void _openReview({
    required SongDraft initialDraft,
    required String helperMessage,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SongImportReviewScreen(
          controller: widget.controller,
          importResult: _currentImportResult,
          initialDraft: initialDraft,
          helperMessage: helperMessage,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Procesando')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: _status == _ProcessingStatus.processing
                ? _ProcessingStateCard(
                    importResult: _currentImportResult,
                    title: _currentStatusLabel,
                  )
                : _ProcessingResultCard(
                    importResult: _currentImportResult,
                    status: _status,
                    busy: _busy,
                    retryActionLabel: widget.retryActionLabel,
                    noTextTitle: widget.noTextTitle,
                    noTextMessage: widget.noTextMessage,
                    errorTitle: widget.errorTitle,
                    errorMessage: _errorMessage ?? widget.fallbackErrorMessage,
                    onRetrySelection: _retrySelection,
                    onContinueWithoutText: _continueWithoutText,
                    onPasteText: _openReviewWithClipboard,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProcessingStateCard extends StatelessWidget {
  const _ProcessingStateCard({
    required this.importResult,
    required this.title,
  });

  final SongImportResult importResult;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 3,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Esto puede tardar unos segundos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              switch (importResult.source) {
                SongImportSource.pdf => Icons.picture_as_pdf_outlined,
                SongImportSource.galleryImage => Icons.image_outlined,
                SongImportSource.cameraPhoto => Icons.photo_camera_outlined,
              },
              color: AppColors.primary,
            ),
            title: Text(importResult.fileName),
            subtitle: Text(
              '${importResult.fileTypeLabel} - ${formatFileSize(importResult.sizeBytes)}',
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

class _ProcessingResultCard extends StatelessWidget {
  const _ProcessingResultCard({
    required this.importResult,
    required this.status,
    required this.busy,
    required this.retryActionLabel,
    required this.noTextTitle,
    required this.noTextMessage,
    required this.errorTitle,
    required this.errorMessage,
    required this.onRetrySelection,
    required this.onContinueWithoutText,
    required this.onPasteText,
  });

  final SongImportResult importResult;
  final _ProcessingStatus status;
  final bool busy;
  final String retryActionLabel;
  final String noTextTitle;
  final String noTextMessage;
  final String errorTitle;
  final String errorMessage;
  final VoidCallback onRetrySelection;
  final VoidCallback onContinueWithoutText;
  final VoidCallback onPasteText;

  @override
  Widget build(BuildContext context) {
    final isNoText = status == _ProcessingStatus.noText;

    return ListView(
      shrinkWrap: true,
      children: [
        Icon(
          isNoText ? Icons.find_in_page_outlined : Icons.error_outline_rounded,
          size: 84,
          color: isNoText ? AppColors.textSecondary : AppColors.tertiary,
        ),
        const SizedBox(height: 20),
        Text(
          isNoText ? noTextTitle : errorTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          isNoText ? noTextMessage : errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              switch (importResult.source) {
                SongImportSource.pdf => Icons.picture_as_pdf_outlined,
                SongImportSource.galleryImage => Icons.image_outlined,
                SongImportSource.cameraPhoto => Icons.photo_camera_outlined,
              },
              color: AppColors.primary,
            ),
            title: Text(importResult.fileName),
            subtitle: Text(
              '${importResult.fileTypeLabel} - ${formatFileSize(importResult.sizeBytes)}',
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy ? null : onRetrySelection,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(retryActionLabel),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : onPasteText,
          icon: const Icon(Icons.content_paste_go),
          label: const Text('Pegar texto'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : onContinueWithoutText,
          icon: const Icon(Icons.edit_note_outlined),
          label: const Text('Escribir manualmente'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
