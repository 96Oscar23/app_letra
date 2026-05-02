import 'dart:io';

import '../domain/song_draft.dart';
import '../utils/song_text_parser.dart';
import 'song_import_result.dart';
import 'song_pdf_import_service.dart';

class SongPdfTextExtraction {
  const SongPdfTextExtraction({
    required this.rawText,
    required this.normalizedText,
    required this.initialDraft,
  });

  final String rawText;
  final String normalizedText;
  final SongDraft initialDraft;

  bool get hasText => normalizedText.trim().isNotEmpty;
}

class SongPdfTextExtractor {
  const SongPdfTextExtractor(this._importService);

  final SongPdfImportService _importService;

  Future<SongPdfTextExtraction> extractText(
    SongImportResult importResult,
  ) async {
    if (!isPdfFileName(importResult.fileName) &&
        !isPdfFileName(importResult.localPath)) {
      throw const SongImportException(
        'El archivo seleccionado no es un PDF valido.',
      );
    }

    final file = File(importResult.localPath);
    if (!await file.exists()) {
      throw const SongImportException(
        'No se encontro el PDF seleccionado para procesarlo.',
      );
    }

    final fileSize = await file.length();
    if (fileSize <= 0) {
      throw const SongImportException(
        'El PDF esta vacio o no se pudo leer correctamente.',
      );
    }

    try {
      final rawText = await _importService.readText(importResult.localPath);
      final normalizedText = _normalizeExtractedText(rawText);
      final parsedDraft = SongTextParser.parse(normalizedText);
      final detectedTitle = _detectTitle(
        normalizedText: normalizedText,
        fallbackTitle: importResult.suggestedTitle,
      );

      final initialDraft = parsedDraft.copyWith(
        title: parsedDraft.title.trim().isNotEmpty
            ? parsedDraft.title
            : detectedTitle,
        lyrics: normalizedText,
      );

      return SongPdfTextExtraction(
        rawText: rawText,
        normalizedText: normalizedText,
        initialDraft: initialDraft,
      );
    } on SongPdfReadException catch (error) {
      throw SongImportException(_mapPdfReadError(error.message));
    } on SongImportException {
      rethrow;
    } catch (_) {
      throw const SongImportException(
        'No se pudo leer el PDF seleccionado.',
      );
    }
  }

  static String _normalizeExtractedText(String rawText) {
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

  static String _detectTitle({
    required String normalizedText,
    required String fallbackTitle,
  }) {
    final lines = normalizedText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return fallbackTitle;
    }

    for (final line in lines.take(4)) {
      final lower = line.toLowerCase();
      if (lower.startsWith('titulo:')) {
        final value = line.split(':').skip(1).join(':').trim();
        if (value.isNotEmpty) {
          return value;
        }
      }
    }

    final firstLine = lines.first;
    if (_looksLikeTitle(firstLine)) {
      return firstLine;
    }

    return fallbackTitle;
  }

  static bool _looksLikeTitle(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 3 || trimmed.length > 80) {
      return false;
    }
    if (RegExp(r'\d{4,}').hasMatch(trimmed)) {
      return false;
    }
    if (trimmed.contains('@') || trimmed.contains('http')) {
      return false;
    }
    final wordCount =
        trimmed.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    return wordCount <= 10;
  }

  static String _mapPdfReadError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('password') ||
        lower.contains('protected') ||
        lower.contains('encrypt')) {
      return 'El PDF parece estar protegido y no se pudo extraer texto.';
    }
    if (lower.contains('corrupt') ||
        lower.contains('damaged') ||
        lower.contains('invalid') ||
        lower.contains('malformed')) {
      return 'El PDF esta dañado o tiene un formato invalido.';
    }
    return 'No se pudo leer el PDF seleccionado.';
  }
}
