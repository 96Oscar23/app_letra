import 'dart:io';

import 'song_import_result.dart';
import 'song_ocr_service.dart';

class SongImageTextExtraction {
  const SongImageTextExtraction({
    required this.rawText,
    required this.normalizedText,
  });

  final String rawText;
  final String normalizedText;

  bool get hasText => normalizedText.trim().isNotEmpty;
}

class SongImageTextExtractor {
  const SongImageTextExtractor(this._ocrService);

  final SongOcrService _ocrService;

  Future<SongImageTextExtraction> extractText(
    SongImportResult importResult, {
    void Function(SongOcrStage stage)? onStageChanged,
  }) async {
    if (!importResult.supportsOcr) {
      throw const SongImportException(
        'La extraccion OCR solo esta disponible para imagenes y fotos.',
      );
    }

    if (!isAcceptedImageFileName(importResult.fileName) &&
        !isAcceptedImageFileName(importResult.localPath)) {
      throw const SongImportException(
        'La imagen seleccionada no tiene un formato soportado.',
      );
    }

    final file = File(importResult.localPath);
    if (!await file.exists()) {
      throw const SongImportException(
        'No se encontro la imagen seleccionada para procesarla.',
      );
    }

    final rawText = await _ocrService.recognizeText(
      importResult.localPath,
      onStageChanged: onStageChanged,
    );

    return SongImageTextExtraction(
      rawText: rawText,
      normalizedText: normalizeExtractedText(rawText),
    );
  }

  static String normalizeExtractedText(String rawText) {
    final lines = rawText
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((line) => line.trimRight())
        .toList();

    final joined = lines.join('\n').trim();
    if (joined.isEmpty) {
      return '';
    }

    return joined.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  }
}
