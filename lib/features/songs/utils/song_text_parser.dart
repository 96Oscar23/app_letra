import '../domain/song.dart';
import '../domain/song_draft.dart';

class SongTextParser {
  static SongDraft parse(String rawText) {
    final normalizedText = rawText.replaceAll('\r\n', '\n');
    final lines = normalizedText.split('\n');

    String title = '';
    String author = '';
    String baseKey = '';
    String capo = '';
    int? bpm;
    String category = '';
    String notes = '';
    String status = SongStatuses.active;
    List<String> tags = const [];
    final lyricLines = <String>[];

    for (final line in lines) {
      final parsedField = _parseField(line);
      if (parsedField == null) {
        lyricLines.add(line);
        continue;
      }

      switch (parsedField.key) {
        case 'titulo':
        case 'title':
          title = parsedField.value;
          break;
        case 'autor':
        case 'artista':
        case 'author':
          author = parsedField.value;
          break;
        case 'tono':
        case 'tone':
          baseKey = parsedField.value;
          break;
        case 'capo':
          capo = parsedField.value;
          break;
        case 'bpm':
          bpm = int.tryParse(parsedField.value);
          break;
        case 'categoria':
        case 'category':
          category = parsedField.value;
          break;
        case 'etiquetas':
        case 'tags':
          tags = _parseTags(parsedField.value);
          break;
        case 'notas':
        case 'notes':
          notes = parsedField.value;
          break;
        case 'estado':
        case 'status':
          status = parsedField.value.isEmpty
              ? SongStatuses.active
              : parsedField.value;
          break;
        default:
          lyricLines.add(line);
      }
    }

    return SongDraft(
      title: title,
      lyrics: _trimOuterEmptyLines(lyricLines.join('\n')),
      baseKey: baseKey,
      author: author,
      category: category,
      notes: notes,
      capo: capo,
      bpm: bpm,
      tags: tags,
      status: status,
    );
  }

  static _ParsedField? _parseField(String line) {
    final separatorIndex = line.indexOf(':');
    if (separatorIndex <= 0) {
      return null;
    }

    final rawKey = line.substring(0, separatorIndex).trim().toLowerCase();
    final value = line.substring(separatorIndex + 1).trim();
    final key = _normalize(rawKey);

    const supportedKeys = {
      'titulo',
      'title',
      'autor',
      'artista',
      'author',
      'tono',
      'tone',
      'capo',
      'bpm',
      'categoria',
      'category',
      'etiquetas',
      'tags',
      'notas',
      'notes',
      'estado',
      'status',
    };

    if (!supportedKeys.contains(key)) {
      return null;
    }

    return _ParsedField(key, value);
  }

  static List<String> _parseTags(String value) {
    return value
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  static String _trimOuterEmptyLines(String value) {
    final lines = value.split('\n');
    while (lines.isNotEmpty && lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }
    while (lines.isNotEmpty && lines.last.trim().isEmpty) {
      lines.removeLast();
    }
    return lines.join('\n');
  }

  static String _normalize(String value) {
    return value
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }
}

class _ParsedField {
  const _ParsedField(this.key, this.value);

  final String key;
  final String value;
}
