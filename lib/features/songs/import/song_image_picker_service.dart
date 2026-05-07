import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'song_import_result.dart';

class SongImagePickerService {
  SongImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<SongImportResult?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
    );

    if (file == null) {
      return null;
    }

    return _mapFile(
      file,
      source: SongImportSource.galleryImage,
      fileTypeLabel: 'Imagen',
    );
  }

  Future<SongImportResult?> takePhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 92,
      );

      if (file == null) {
        return null;
      }

      return _mapFile(
        file,
        source: SongImportSource.cameraPhoto,
        fileTypeLabel: 'Foto',
      );
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      final message = (error.message ?? '').toLowerCase();
      if (code.contains('camera_access_denied') ||
          code.contains('permission') ||
          message.contains('permission') ||
          message.contains('denied')) {
        throw const SongImportException(
          'No se concedio permiso para usar la camara. Si lo rechazaste antes, activalo desde ajustes.',
        );
      }
      rethrow;
    }
  }

  Future<SongImportResult> _mapFile(
    XFile file, {
    required SongImportSource source,
    required String fileTypeLabel,
  }) async {
    final name = file.name.isEmpty ? file.path.split('\\').last : file.name;
    if (!isAcceptedImageFileName(name) && !isAcceptedImageFileName(file.path)) {
      throw const SongImportException(
        'La imagen seleccionada no tiene un formato soportado.',
      );
    }

    final size = await file.length();
    return SongImportResult(
      source: source,
      localPath: file.path,
      fileName: name,
      fileTypeLabel: fileTypeLabel,
      sizeBytes: size > 0 ? size : null,
    );
  }
}
