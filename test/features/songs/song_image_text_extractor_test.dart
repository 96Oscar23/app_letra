import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/import/song_image_text_extractor.dart';
import 'package:app_letras/features/songs/import/song_import_result.dart';
import 'package:app_letras/features/songs/import/song_ocr_service.dart';

void main() {
  test('normaliza texto OCR conservando saltos utiles', () {
    const rawText = 'Titulo   \r\nVerso 1  \r\n\r\n\r\nCoro  ';

    final normalized = SongImageTextExtractor.normalizeExtractedText(rawText);

    expect(normalized, 'Titulo\nVerso 1\n\nCoro');
  });

  test('extrae texto desde una imagen valida existente', () async {
    final tempDir = await Directory.systemTemp.createTemp('ocr_test');
    final imageFile = File('${tempDir.path}/sample.jpg');
    await imageFile.writeAsBytes(const [1, 2, 3]);

    const extractor = SongImageTextExtractor(
      _FakeSongOcrService('Linea 1\n\n\nLinea 2'),
    );

    final result = await extractor.extractText(
      SongImportResult(
        source: SongImportSource.galleryImage,
        localPath: imageFile.path,
        fileName: 'sample.jpg',
        fileTypeLabel: 'Imagen',
      ),
    );

    expect(result.hasText, isTrue);
    expect(result.normalizedText, 'Linea 1\n\nLinea 2');
  });

  test('falla si el archivo de imagen no existe', () async {
    const extractor = SongImageTextExtractor(
      _FakeSongOcrService('Texto'),
    );

    expect(
      () => extractor.extractText(
        const SongImportResult(
          source: SongImportSource.cameraPhoto,
          localPath: '/no/existe/foto.jpg',
          fileName: 'foto.jpg',
          fileTypeLabel: 'Foto',
        ),
      ),
      throwsA(isA<SongImportException>()),
    );
  });
}

class _FakeSongOcrService implements SongOcrService {
  const _FakeSongOcrService(this.text);

  final String text;

  @override
  Future<String> recognizeText(
    String imagePath, {
    void Function(SongOcrStage stage)? onStageChanged,
  }) async {
    onStageChanged?.call(SongOcrStage.analyzingImage);
    onStageChanged?.call(SongOcrStage.extractingText);
    return text;
  }
}
