import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'song_import_result.dart';

class SongFilePickerService {
  const SongFilePickerService();

  Future<SongImportResult?> pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    if (!isPdfFileName(file.name)) {
      throw const SongImportException(
        'El archivo seleccionado no es un PDF valido.',
      );
    }

    final localPath = await _ensureLocalPath(file);
    return SongImportResult(
      source: SongImportSource.pdf,
      localPath: localPath,
      fileName: file.name,
      fileTypeLabel: 'PDF',
      sizeBytes: file.size > 0 ? file.size : null,
    );
  }

  Future<String> _ensureLocalPath(PlatformFile file) async {
    final existingPath = file.path;
    if (existingPath != null && existingPath.trim().isNotEmpty) {
      return existingPath;
    }

    final bytes = file.bytes;
    if (bytes == null) {
      throw const SongImportException(
        'No se pudo leer el archivo seleccionado.',
      );
    }

    final tempDirectory = await getTemporaryDirectory();
    final importDirectory = Directory(
      path.join(tempDirectory.path, 'song_imports'),
    );
    await importDirectory.create(recursive: true);

    final safeName = file.name.trim().isEmpty ? 'importado.pdf' : file.name;
    final tempFile = File(
      path.join(
        importDirectory.path,
        '${DateTime.now().millisecondsSinceEpoch}_$safeName',
      ),
    );
    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile.path;
  }
}
