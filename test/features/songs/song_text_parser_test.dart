import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/features/songs/domain/song.dart';
import 'package:app_letras/features/songs/utils/song_text_parser.dart';

void main() {
  test('parsea metadatos simples y conserva la letra', () {
    const rawText = '''
Titulo: Cuan Grande es El
Autor: Tradicional
Tono: G
Capo: 2
BPM: 72

Verso 1
Linea 2

Coro
''';

    final draft = SongTextParser.parse(rawText);

    expect(draft.title, 'Cuan Grande es El');
    expect(draft.author, 'Tradicional');
    expect(draft.baseKey, 'G');
    expect(draft.capo, '2');
    expect(draft.bpm, 72);
    expect(draft.lyrics, 'Verso 1\nLinea 2\n\nCoro');
    expect(draft.status, SongStatuses.active);
  });

  test('si no detecta campos, deja todo como letra', () {
    const rawText = '''
Una linea cualquiera

Otra estrofa
''';

    final draft = SongTextParser.parse(rawText);

    expect(draft.title, isEmpty);
    expect(draft.lyrics, 'Una linea cualquiera\n\nOtra estrofa');
  });
}
