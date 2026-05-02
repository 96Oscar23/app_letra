import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'song_import_result.dart';

class SongReferenceStorageService {
  const SongReferenceStorageService();

  Future<SongImportResult> persistReference(SongImportResult result) async {
    final sourceFile = File(result.localPath);
    if (!await sourceFile.exists()) {
      throw const SongImportException(
        'No se encontro el archivo original para guardarlo como referencia.',
      );
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final targetDirectory = Directory(
      path.join(appDirectory.path, 'song_references'),
    );
    await targetDirectory.create(recursive: true);

    final extension = path.extension(result.fileName);
    final baseName = _sanitize(path.basenameWithoutExtension(result.fileName));
    final storedName =
        '${DateTime.now().millisecondsSinceEpoch}_${baseName.isEmpty ? 'referencia' : baseName}$extension';

    final targetPath = path.join(targetDirectory.path, storedName);

    if (path.equals(sourceFile.path, targetPath)) {
      return result;
    }

    final copiedFile = await sourceFile.copy(targetPath);
    return result.copyWith(localPath: copiedFile.path);
  }

  String _sanitize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
