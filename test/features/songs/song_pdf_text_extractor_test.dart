import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/import/song_import_result.dart';
import 'package:app_letras/features/songs/import/song_pdf_import_service.dart';
import 'package:app_letras/features/songs/import/song_pdf_text_extractor.dart';

void main() {
  test('extrae texto y detecta posible titulo desde primeras lineas', () async {
    final tempDir = await Directory.systemTemp.createTemp('pdf_test');
    final pdfFile = File('${tempDir.path}/entrada.pdf');
    await pdfFile.writeAsBytes(const [1, 2, 3, 4]);

    const extractor = SongPdfTextExtractor(
      _FakeSongPdfImportService(
        'Sublime Gracia\nVerso 1\nTu gracia me alcanzo',
      ),
    );

    final result = await extractor.extractText(
      SongImportResult(
        source: SongImportSource.pdf,
        localPath: pdfFile.path,
        fileName: 'entrada.pdf',
        fileTypeLabel: 'PDF',
      ),
    );

    expect(result.hasText, isTrue);
    expect(result.initialDraft.title, 'Sublime Gracia');
    expect(result.initialDraft.lyrics, contains('Verso 1'));
  });

  test('si no hay texto devuelve extraccion vacia y conserva fallback',
      () async {
    final tempDir = await Directory.systemTemp.createTemp('pdf_empty_test');
    final pdfFile = File('${tempDir.path}/gracia.pdf');
    await pdfFile.writeAsBytes(const [1, 2, 3, 4]);

    const extractor = SongPdfTextExtractor(
      _FakeSongPdfImportService(''),
    );

    final result = await extractor.extractText(
      SongImportResult(
        source: SongImportSource.pdf,
        localPath: pdfFile.path,
        fileName: 'gracia.pdf',
        fileTypeLabel: 'PDF',
      ),
    );

    expect(result.hasText, isFalse);
    expect(result.initialDraft.title, 'Gracia');
  });

  test('rechaza archivo no pdf', () async {
    const extractor = SongPdfTextExtractor(
      _FakeSongPdfImportService('Texto'),
    );

    expect(
      () => extractor.extractText(
        const SongImportResult(
          source: SongImportSource.pdf,
          localPath: '/tmp/canto.txt',
          fileName: 'canto.txt',
          fileTypeLabel: 'TXT',
        ),
      ),
      throwsA(isA<SongImportException>()),
    );
  });

  test('mapea errores de PDF protegido', () async {
    final tempDir = await Directory.systemTemp.createTemp('pdf_protected_test');
    final pdfFile = File('${tempDir.path}/privado.pdf');
    await pdfFile.writeAsBytes(const [1, 2, 3, 4]);

    const extractor = SongPdfTextExtractor(
      _ThrowingSongPdfImportService(
        SongPdfReadException('Password protected document'),
      ),
    );

    expect(
      () => extractor.extractText(
        SongImportResult(
          source: SongImportSource.pdf,
          localPath: pdfFile.path,
          fileName: 'privado.pdf',
          fileTypeLabel: 'PDF',
        ),
      ),
      throwsA(
        isA<SongImportException>().having(
          (error) => error.message,
          'message',
          contains('protegido'),
        ),
      ),
    );
  });
}

class _FakeSongPdfImportService implements SongPdfImportService {
  const _FakeSongPdfImportService(this.text);

  final String text;

  @override
  Future<String> readText(String path) async => text;
}

class _ThrowingSongPdfImportService implements SongPdfImportService {
  const _ThrowingSongPdfImportService(this.error);

  final Exception error;

  @override
  Future<String> readText(String path) => Future<String>.error(error);
}
