import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/data/in_memory_song_repository.dart';
import 'package:app_letras/features/songs/domain/song.dart';
import 'package:app_letras/features/songs/import/imported_file_storage.dart';
import 'package:app_letras/features/songs/songs_controller.dart';

void main() {
  test('quitar referencia conserva el canto y limpia metadatos', () async {
    final repository = InMemorySongRepository(
      initialSongs: [
        Song(
          id: 1,
          title: 'Canto',
          lyrics: 'Letra',
          baseKey: 'C',
          author: '',
          category: '',
          notes: '',
          capo: '',
          bpm: null,
          tags: const [],
          status: SongStatuses.active,
          referenceFilePath: '/tmp/ref.pdf',
          referenceFileName: 'ref.pdf',
          referenceFileType: 'PDF',
          referenceFileExtension: 'pdf',
          referenceFileSizeBytes: 100,
          referenceImportedAt: DateTime(2026, 5, 2),
          isFavorite: false,
          createdAt: DateTime(2026, 5, 2),
          updatedAt: DateTime(2026, 5, 2),
        ),
      ],
    );
    final storage = _FakeImportedFileStorage();
    final controller = SongsController(
      repository,
      importedFileStorage: storage,
    );

    final song = await repository.findById(1);
    await controller.removeReference(song!);

    final updated = await repository.findById(1);

    expect(updated, isNotNull);
    expect(updated!.hasReference, isFalse);
    expect(updated.referenceFilePath, '');
    expect(updated.referenceFileName, '');
    expect(updated.referenceFileType, '');
    expect(updated.referenceFileExtension, '');
    expect(updated.referenceImportedAt, isNull);
    expect(storage.deletedPaths, ['/tmp/ref.pdf']);
  });

  test('borrar canto elimina referencia asociada si existe', () async {
    final repository = InMemorySongRepository(
      initialSongs: [
        Song(
          id: 1,
          title: 'Canto',
          lyrics: 'Letra',
          baseKey: 'C',
          author: '',
          category: '',
          notes: '',
          capo: '',
          bpm: null,
          tags: const [],
          status: SongStatuses.active,
          referenceFilePath: '/tmp/foto.jpg',
          referenceFileName: 'foto.jpg',
          referenceFileType: 'Foto',
          referenceFileExtension: 'jpg',
          referenceFileSizeBytes: 100,
          referenceImportedAt: DateTime(2026, 5, 2),
          isFavorite: false,
          createdAt: DateTime(2026, 5, 2),
          updatedAt: DateTime(2026, 5, 2),
        ),
      ],
    );
    final storage = _FakeImportedFileStorage();
    final controller = SongsController(
      repository,
      importedFileStorage: storage,
    );

    await controller.deleteSong(1);

    expect(await repository.findById(1), isNull);
    expect(storage.deletedPaths, ['/tmp/foto.jpg']);
  });
}

class _FakeImportedFileStorage extends ImportedFileStorage {
  final List<String> deletedPaths = [];

  @override
  Future<void> deleteIfExists(String? filePath) async {
    if (filePath != null && filePath.isNotEmpty) {
      deletedPaths.add(filePath);
    }
  }
}
