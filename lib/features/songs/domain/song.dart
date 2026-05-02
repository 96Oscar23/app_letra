import 'dart:convert';

class Song {
  const Song({
    this.id,
    required this.title,
    required this.lyrics,
    required this.baseKey,
    required this.author,
    required this.category,
    required this.notes,
    required this.capo,
    required this.bpm,
    required this.tags,
    required this.status,
    this.referenceFilePath,
    this.referenceFileName,
    this.referenceFileType,
    this.referenceFileSizeBytes,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String title;
  final String lyrics;
  final String baseKey;
  final String author;
  final String category;
  final String notes;
  final String capo;
  final int? bpm;
  final List<String> tags;
  final String status;
  final String? referenceFilePath;
  final String? referenceFileName;
  final String? referenceFileType;
  final int? referenceFileSizeBytes;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasReference =>
      (referenceFilePath?.trim().isNotEmpty ?? false) ||
      (referenceFileName?.trim().isNotEmpty ?? false);

  Song copyWith({
    int? id,
    String? title,
    String? lyrics,
    String? baseKey,
    String? author,
    String? category,
    String? notes,
    String? capo,
    int? bpm,
    List<String>? tags,
    String? status,
    String? referenceFilePath,
    String? referenceFileName,
    String? referenceFileType,
    int? referenceFileSizeBytes,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
      baseKey: baseKey ?? this.baseKey,
      author: author ?? this.author,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      capo: capo ?? this.capo,
      bpm: bpm ?? this.bpm,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      referenceFilePath: referenceFilePath ?? this.referenceFilePath,
      referenceFileName: referenceFileName ?? this.referenceFileName,
      referenceFileType: referenceFileType ?? this.referenceFileType,
      referenceFileSizeBytes:
          referenceFileSizeBytes ?? this.referenceFileSizeBytes,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'lyrics': lyrics,
      'base_key': baseKey,
      'author': author,
      'category': category,
      'notes': notes,
      'capo': capo,
      'bpm': bpm,
      'tags': jsonEncode(tags),
      'status': status,
      'reference_file_path': referenceFilePath,
      'reference_file_name': referenceFileName,
      'reference_file_type': referenceFileType,
      'reference_file_size_bytes': referenceFileSizeBytes,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Song.fromMap(Map<String, Object?> map) {
    return Song(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      lyrics: map['lyrics'] as String? ?? '',
      baseKey: map['base_key'] as String? ?? '',
      author: map['author'] as String? ?? '',
      category: map['category'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      capo: map['capo'] as String? ?? '',
      bpm: map['bpm'] as int?,
      tags: _tagsFromStoredValue(map['tags']),
      status: map['status'] as String? ?? SongStatuses.active,
      referenceFilePath: map['reference_file_path'] as String?,
      referenceFileName: map['reference_file_name'] as String?,
      referenceFileType: map['reference_file_type'] as String?,
      referenceFileSizeBytes: map['reference_file_size_bytes'] as int?,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  static List<String> _tagsFromStoredValue(Object? rawValue) {
    if (rawValue is! String || rawValue.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .whereType<String>()
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      }
    } catch (_) {
      return rawValue
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    }

    return const [];
  }
}

class SongStatuses {
  static const draft = 'Borrador';
  static const active = 'Activo';
  static const archived = 'Archivado';

  static const values = [draft, active, archived];
}
