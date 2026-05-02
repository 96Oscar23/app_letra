import '../domain/song.dart';

class SongPlainTextFormatter {
  static String lyricsOnly(Song song) => song.lyrics;

  static String fullSong(Song song) {
    final lines = <String>[
      'Titulo: ${song.title}',
      if (song.author.trim().isNotEmpty) 'Autor: ${song.author}',
      if (song.baseKey.trim().isNotEmpty) 'Tono: ${song.baseKey}',
      if (song.capo.trim().isNotEmpty) 'Capo: ${song.capo}',
      if (song.bpm != null) 'BPM: ${song.bpm}',
      if (song.category.trim().isNotEmpty) 'Categoria: ${song.category}',
      if (song.tags.isNotEmpty) 'Etiquetas: ${song.tags.join(', ')}',
      if (song.status.trim().isNotEmpty) 'Estado: ${song.status}',
      if (song.notes.trim().isNotEmpty) 'Notas: ${song.notes}',
      '',
      song.lyrics,
    ];

    return lines.join('\n').trim();
  }
}
