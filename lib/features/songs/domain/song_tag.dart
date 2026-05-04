class SongTag {
  const SongTag({
    this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.usageCount = 0,
  });

  final int? id;
  final String name;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int usageCount;

  bool get isSeasonEvent => type == SongTagTypes.seasonEvent;
  bool get isCustom => type == SongTagTypes.custom;

  SongTag copyWith({
    int? id,
    String? name,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? usageCount,
  }) {
    return SongTag(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SongTag.fromMap(Map<String, Object?> map) {
    return SongTag(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      type: map['type'] as String? ?? SongTagTypes.custom,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      usageCount: map['usage_count'] as int? ?? 0,
    );
  }
}

class SongTagTypes {
  static const custom = 'personalizada';
  static const seasonEvent = 'temporada_evento';
  static const system = 'sistema';
}
