import 'dart:convert';

class Song {
  const Song({
    this.id,
    required this.title,
    required this.lyrics,
    required this.baseKey,
    required this.author,
    required this.category,
    required this.genre,
    required this.notes,
    required this.capo,
    required this.bpm,
    required this.tags,
    required this.status,
    this.referenceFilePath,
    this.referenceFileName,
    this.referenceFileType,
    this.referenceFileExtension,
    this.referenceFileSizeBytes,
    this.referenceImportedAt,
    this.lastOpenedAt,
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
  final String genre;
  final String notes;
  final String capo;
  final int? bpm;
  final List<String> tags;
  final String status;
  final String? referenceFilePath;
  final String? referenceFileName;
  final String? referenceFileType;
  final String? referenceFileExtension;
  final int? referenceFileSizeBytes;
  final DateTime? referenceImportedAt;
  final DateTime? lastOpenedAt;
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
    String? genre,
    String? notes,
    String? capo,
    int? bpm,
    List<String>? tags,
    String? status,
    Object? referenceFilePath = _sentinel,
    Object? referenceFileName = _sentinel,
    Object? referenceFileType = _sentinel,
    Object? referenceFileExtension = _sentinel,
    Object? referenceFileSizeBytes = _sentinel,
    Object? referenceImportedAt = _sentinel,
    Object? lastOpenedAt = _sentinel,
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
      genre: genre ?? this.genre,
      notes: notes ?? this.notes,
      capo: capo ?? this.capo,
      bpm: bpm ?? this.bpm,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      referenceFilePath: referenceFilePath == _sentinel
          ? this.referenceFilePath
          : referenceFilePath as String?,
      referenceFileName: referenceFileName == _sentinel
          ? this.referenceFileName
          : referenceFileName as String?,
      referenceFileType: referenceFileType == _sentinel
          ? this.referenceFileType
          : referenceFileType as String?,
      referenceFileExtension: referenceFileExtension == _sentinel
          ? this.referenceFileExtension
          : referenceFileExtension as String?,
      referenceFileSizeBytes: referenceFileSizeBytes == _sentinel
          ? this.referenceFileSizeBytes
          : referenceFileSizeBytes as int?,
      referenceImportedAt: referenceImportedAt == _sentinel
          ? this.referenceImportedAt
          : referenceImportedAt as DateTime?,
      lastOpenedAt: lastOpenedAt == _sentinel
          ? this.lastOpenedAt
          : lastOpenedAt as DateTime?,
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
      'genre': genre,
      'notes': notes,
      'capo': capo,
      'bpm': bpm,
      'tags': jsonEncode(tags),
      'status': status,
      'reference_file_path': referenceFilePath,
      'reference_file_name': referenceFileName,
      'reference_file_type': referenceFileType,
      'reference_file_extension': referenceFileExtension,
      'reference_file_size_bytes': referenceFileSizeBytes,
      'reference_imported_at': referenceImportedAt?.toIso8601String(),
      'last_opened_at': lastOpenedAt?.toIso8601String(),
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
      genre: map['genre'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      capo: map['capo'] as String? ?? '',
      bpm: map['bpm'] as int?,
      tags: _tagsFromStoredValue(map['tags']),
      status: map['status'] as String? ?? SongStatuses.active,
      referenceFilePath: map['reference_file_path'] as String?,
      referenceFileName: map['reference_file_name'] as String?,
      referenceFileType: map['reference_file_type'] as String?,
      referenceFileExtension: map['reference_file_extension'] as String?,
      referenceFileSizeBytes: map['reference_file_size_bytes'] as int?,
      referenceImportedAt: _parseOptionalDate(
        map['reference_imported_at'] as String?,
      ),
      lastOpenedAt: _parseOptionalDate(map['last_opened_at'] as String?),
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  static DateTime? _parseOptionalDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
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

const _sentinel = Object();

class SongStatuses {
  static const draft = 'Borrador';
  static const active = 'Activo';
  static const archived = 'Archivado';

  static const values = [draft, active, archived];
}
