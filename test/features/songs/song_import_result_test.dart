import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/import/song_import_result.dart';

void main() {
  test('formatea tamano legible y detecta extensiones validas', () {
    expect(isPdfFileName('canto.pdf'), isTrue);
    expect(isPdfFileName('canto.txt'), isFalse);

    expect(isAcceptedImageFileName('foto.JPG'), isTrue);
    expect(isAcceptedImageFileName('foto.gif'), isFalse);

    expect(formatFileSize(840), '840 B');
    expect(formatFileSize(2048), '2.0 KB');
    expect(formatFileSize(3 * 1024 * 1024), '3.0 MB');
  });

  test('sugiere titulo a partir del archivo cuando aplica', () {
    const pdfResult = SongImportResult(
      source: SongImportSource.pdf,
      localPath: '/tmp/canto.pdf',
      fileName: 'cuan_grande_eres_tu.pdf',
      fileTypeLabel: 'PDF',
      sizeBytes: 100,
    );

    const cameraResult = SongImportResult(
      source: SongImportSource.cameraPhoto,
      localPath: '/tmp/image_picker_01.jpg',
      fileName: 'image_picker_01.jpg',
      fileTypeLabel: 'Foto',
      sizeBytes: 100,
    );

    expect(pdfResult.suggestedTitle, 'Cuan Grande Eres Tu');
    expect(cameraResult.suggestedTitle, 'Nuevo canto desde foto');
  });
}
