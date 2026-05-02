import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/domain/song.dart';
import 'package:app_letras/features/songs/utils/song_plain_text_formatter.dart';

void main() {
  test('exporta canto completo a texto simple', () {
    final song = Song(
      id: 1,
      title: 'Lumen Vesper',
      lyrics: 'Verso 1\nCoro',
      baseKey: 'C',
      author: 'Equipo',
      category: 'Adoracion',
      notes: 'Version acustica',
      capo: '2',
      bpm: 74,
      tags: const ['ensayo', 'apertura'],
      status: SongStatuses.active,
      isFavorite: false,
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime(2026, 5, 1),
    );

    final text = SongPlainTextFormatter.fullSong(song);

    expect(text, contains('Titulo: Lumen Vesper'));
    expect(text, contains('Autor: Equipo'));
    expect(text, contains('Capo: 2'));
    expect(text, contains('BPM: 74'));
    expect(text, contains('Etiquetas: ensayo, apertura'));
    expect(text, contains('Verso 1\nCoro'));
  });
}
