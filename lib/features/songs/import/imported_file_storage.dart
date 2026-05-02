import 'dart:io';

import 'package:open_filex/open_filex.dart';

import '../domain/song.dart';
import 'song_import_result.dart';

class ImportedFileStorage {
  const ImportedFileStorage();

  Future<bool> exists(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) {
      return false;
    }
    return File(filePath).exists();
  }

  Future<void> deleteIfExists(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) {
      return;
    }

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> openReference(Song song) async {
    final filePath = song.referenceFilePath;
    if (!await exists(filePath)) {
      throw const SongImportException(
        'El archivo de referencia ya no existe en el dispositivo.',
      );
    }

    final result = await OpenFilex.open(filePath!);
    if (result.type != ResultType.done) {
      throw SongImportException(
        result.message.trim().isEmpty
            ? 'No se pudo abrir el archivo de referencia.'
            : result.message,
      );
    }
  }
}
