import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

abstract class SongPdfImportService {
  Future<String> readText(String path);
}

class ReadPdfSongImportService implements SongPdfImportService {
  const ReadPdfSongImportService();

  @override
  Future<String> readText(String path) async {
    try {
      return await ReadPdfText.getPDFtext(path);
    } on PlatformException catch (error) {
      final message = error.message?.trim();
      if (message == null || message.isEmpty) {
        rethrow;
      }
      throw SongPdfReadException(message);
    }
  }
}

class SongPdfReadException implements Exception {
  const SongPdfReadException(this.message);

  final String message;

  @override
  String toString() => message;
}
