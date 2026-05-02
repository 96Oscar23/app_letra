import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/domain/song.dart';
import 'package:app_letras/features/songs/domain/song_draft.dart';

void main() {
  test('preserva metadatos de archivo de referencia en draft y song', () {
    final draft = SongDraft(
      title: 'Canto',
      lyrics: 'Letra',
      referenceFilePath: '/docs/referencia.pdf',
      referenceFileName: 'referencia.pdf',
      referenceFileType: 'PDF',
      referenceFileExtension: 'pdf',
      referenceFileSizeBytes: 4096,
      referenceImportedAt: DateTime(2026, 5, 2),
    );

    final song = draft.toSong(
      id: 1,
      isFavorite: false,
      createdAt: DateTime(2026, 5, 2),
      updatedAt: DateTime(2026, 5, 2),
    );

    expect(song.hasReference, isTrue);
    expect(song.referenceFilePath, '/docs/referencia.pdf');
    expect(song.referenceFileName, 'referencia.pdf');
    expect(song.referenceFileType, 'PDF');
    expect(song.referenceFileExtension, 'pdf');
    expect(song.referenceFileSizeBytes, 4096);
    expect(song.referenceImportedAt, DateTime(2026, 5, 2));

    final rebuiltDraft = SongDraft.fromSong(song);

    expect(rebuiltDraft.referenceFilePath, '/docs/referencia.pdf');
    expect(rebuiltDraft.referenceFileName, 'referencia.pdf');
    expect(rebuiltDraft.referenceFileType, 'PDF');
    expect(rebuiltDraft.referenceFileExtension, 'pdf');
    expect(rebuiltDraft.referenceFileSizeBytes, 4096);
    expect(rebuiltDraft.referenceImportedAt, DateTime(2026, 5, 2));
  });

  test('serializa metadatos de referencia hacia sqlite map', () {
    final song = Song(
      id: 7,
      title: 'Canto',
      lyrics: 'Letra',
      baseKey: 'G',
      author: 'Autor',
      category: '',
      notes: '',
      capo: '',
      bpm: 80,
      tags: const ['tag'],
      status: SongStatuses.active,
      referenceFilePath: '/files/foto.jpg',
      referenceFileName: 'foto.jpg',
      referenceFileType: 'Foto',
      referenceFileExtension: 'jpg',
      referenceFileSizeBytes: 5120,
      referenceImportedAt: DateTime(2026, 5, 2, 10, 30),
      isFavorite: false,
      createdAt: DateTime(2026, 5, 2),
      updatedAt: DateTime(2026, 5, 2),
    );

    final rebuilt = Song.fromMap(song.toMap());

    expect(rebuilt.referenceFilePath, '/files/foto.jpg');
    expect(rebuilt.referenceFileName, 'foto.jpg');
    expect(rebuilt.referenceFileType, 'Foto');
    expect(rebuilt.referenceFileExtension, 'jpg');
    expect(rebuilt.referenceFileSizeBytes, 5120);
    expect(rebuilt.referenceImportedAt, DateTime(2026, 5, 2, 10, 30));
  });
}
