import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/data/in_memory_song_repository.dart';
import 'package:app_letras/features/songs/domain/song.dart';
import 'package:app_letras/features/songs/domain/song_draft.dart';
import 'package:app_letras/features/songs/domain/song_library_filters.dart';
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
          genre: 'Himno',
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
          genre: 'Worship',
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

  test('registrar apertura actualiza ultimo uso sin duplicar el canto',
      () async {
    final repository = InMemorySongRepository(
      initialSongs: [
        Song(
          id: 1,
          title: 'Canto',
          lyrics: 'Letra',
          baseKey: 'C',
          author: '',
          category: '',
          genre: 'Worship',
          notes: '',
          capo: '',
          bpm: null,
          tags: const [],
          status: SongStatuses.active,
          isFavorite: false,
          createdAt: DateTime(2026, 5, 2),
          updatedAt: DateTime(2026, 5, 2),
        ),
      ],
    );
    final controller = SongsController(repository);

    await controller.markSongOpened(1);
    final firstOpen = await repository.findById(1);
    expect(firstOpen, isNotNull);
    expect(firstOpen!.lastOpenedAt, isNotNull);

    final firstTimestamp = firstOpen.lastOpenedAt!;

    await Future<void>.delayed(const Duration(milliseconds: 5));
    await controller.markSongOpened(1);

    final reopened = await repository.findById(1);
    final recentSongs = await repository.fetchSongs(recentOnly: true);

    expect(reopened, isNotNull);
    expect(reopened!.lastOpenedAt, isNotNull);
    expect(reopened.lastOpenedAt!.isAfter(firstTimestamp), isTrue);
    expect(recentSongs, hasLength(1));
    expect(recentSongs.first.id, 1);
  });

  test('crea etiquetas, las asigna y permite filtrar por etiqueta', () async {
    final repository = InMemorySongRepository(
      initialSongs: [
        Song(
          id: 1,
          title: 'Canto',
          lyrics: 'Letra',
          baseKey: 'C',
          author: '',
          category: '',
          genre: 'Worship',
          notes: '',
          capo: '',
          bpm: null,
          tags: const [],
          status: SongStatuses.active,
          isFavorite: false,
          createdAt: DateTime(2026, 5, 2),
          updatedAt: DateTime(2026, 5, 2),
        ),
      ],
    );
    final controller = SongsController(repository);

    final songId = await controller.saveDraft(
      id: 1,
      draft: const SongDraft(
        title: 'Canto',
        lyrics: 'Letra',
        genre: 'Worship',
        tags: ['Navidad'],
      ),
    );

    final saved = await repository.findById(songId);
    expect(saved, isNotNull);
    expect(saved!.tags, ['Navidad']);

    await controller.setLibraryFilters(
      const SongLibraryFilters(tags: {'Navidad'}),
    );

    expect(controller.songs, hasLength(1));
    expect(controller.songs.first.tags, contains('Navidad'));
  });

  test('eliminar etiqueta asignada conserva el canto y limpia relaciones',
      () async {
    final repository = InMemorySongRepository(
      initialSongs: [
        Song(
          id: 1,
          title: 'Canto',
          lyrics: 'Letra',
          baseKey: 'C',
          author: '',
          category: '',
          genre: 'Worship',
          notes: '',
          capo: '',
          bpm: null,
          tags: const ['Congreso'],
          status: SongStatuses.active,
          isFavorite: false,
          createdAt: DateTime(2026, 5, 2),
          updatedAt: DateTime(2026, 5, 2),
        ),
      ],
    );
    final controller = SongsController(repository);

    await controller.refreshTags();
    final tag = controller.tags.firstWhere((item) => item.name == 'Congreso');

    await controller.deleteTag(tag);

    final song = await repository.findById(1);
    expect(song, isNotNull);
    expect(song!.tags, isEmpty);
    expect(await repository.fetchTags(), isEmpty);
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
