import 'package:path/path.dart' as path;

enum SongImportSource {
  pdf,
  galleryImage,
  cameraPhoto,
}

class SongImportResult {
  const SongImportResult({
    required this.source,
    required this.localPath,
    required this.fileName,
    required this.fileTypeLabel,
    this.sizeBytes,
  });

  final SongImportSource source;
  final String localPath;
  final String fileName;
  final String fileTypeLabel;
  final int? sizeBytes;

  bool get supportsPreview => source != SongImportSource.pdf;
  bool get supportsOcr => source != SongImportSource.pdf;

  String get sourceLabel => switch (source) {
        SongImportSource.pdf => 'archivo PDF',
        SongImportSource.galleryImage => 'imagen',
        SongImportSource.cameraPhoto => 'foto',
      };

  String get suggestedTitle {
    final stem = path.basenameWithoutExtension(fileName).trim();
    if (stem.isEmpty || stem.toLowerCase().startsWith('image_picker')) {
      return source == SongImportSource.cameraPhoto
          ? 'Nuevo canto desde foto'
          : '';
    }

    final normalized = stem
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) {
      return '';
    }

    return normalized
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  SongImportResult copyWith({
    SongImportSource? source,
    String? localPath,
    String? fileName,
    String? fileTypeLabel,
    int? sizeBytes,
  }) {
    return SongImportResult(
      source: source ?? this.source,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      fileTypeLabel: fileTypeLabel ?? this.fileTypeLabel,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}

class SongImportException implements Exception {
  const SongImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

bool isPdfFileName(String value) {
  return path.extension(value).toLowerCase() == '.pdf';
}

bool isAcceptedImageFileName(String value) {
  const allowedExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.heic',
    '.heif',
  };
  return allowedExtensions.contains(path.extension(value).toLowerCase());
}

String formatFileSize(int? bytes) {
  if (bytes == null || bytes <= 0) {
    return 'Tamano no disponible';
  }
  if (bytes < 1024) {
    return '$bytes B';
  }
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
