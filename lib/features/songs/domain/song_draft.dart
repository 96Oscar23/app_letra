import 'song.dart';

class SongDraft {
  const SongDraft({
    this.title = '',
    this.lyrics = '',
    this.baseKey = '',
    this.author = '',
    this.category = '',
    this.notes = '',
    this.capo = '',
    this.bpm,
    this.tags = const [],
    this.status = SongStatuses.active,
    this.referenceFilePath,
    this.referenceFileName,
    this.referenceFileType,
    this.referenceFileExtension,
    this.referenceFileSizeBytes,
    this.referenceImportedAt,
  });

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
  final String? referenceFileExtension;
  final int? referenceFileSizeBytes;
  final DateTime? referenceImportedAt;

  factory SongDraft.fromSong(Song song) {
    return SongDraft(
      title: song.title,
      lyrics: song.lyrics,
      baseKey: song.baseKey,
      author: song.author,
      category: song.category,
      notes: song.notes,
      capo: song.capo,
      bpm: song.bpm,
      tags: song.tags,
      status: song.status,
      referenceFilePath: song.referenceFilePath,
      referenceFileName: song.referenceFileName,
      referenceFileType: song.referenceFileType,
      referenceFileExtension: song.referenceFileExtension,
      referenceFileSizeBytes: song.referenceFileSizeBytes,
      referenceImportedAt: song.referenceImportedAt,
    );
  }

  SongDraft copyWith({
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
    Object? referenceFilePath = _draftSentinel,
    Object? referenceFileName = _draftSentinel,
    Object? referenceFileType = _draftSentinel,
    Object? referenceFileExtension = _draftSentinel,
    Object? referenceFileSizeBytes = _draftSentinel,
    Object? referenceImportedAt = _draftSentinel,
  }) {
    return SongDraft(
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
      referenceFilePath: referenceFilePath == _draftSentinel
          ? this.referenceFilePath
          : referenceFilePath as String?,
      referenceFileName: referenceFileName == _draftSentinel
          ? this.referenceFileName
          : referenceFileName as String?,
      referenceFileType: referenceFileType == _draftSentinel
          ? this.referenceFileType
          : referenceFileType as String?,
      referenceFileExtension: referenceFileExtension == _draftSentinel
          ? this.referenceFileExtension
          : referenceFileExtension as String?,
      referenceFileSizeBytes: referenceFileSizeBytes == _draftSentinel
          ? this.referenceFileSizeBytes
          : referenceFileSizeBytes as int?,
      referenceImportedAt: referenceImportedAt == _draftSentinel
          ? this.referenceImportedAt
          : referenceImportedAt as DateTime?,
    );
  }

  bool get isCompletelyEmpty => title.trim().isEmpty && lyrics.trim().isEmpty;

  Song toSong({
    int? id,
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return Song(
      id: id,
      title: title.trim(),
      lyrics: lyrics.trim(),
      baseKey: baseKey.trim(),
      author: author.trim(),
      category: category.trim(),
      notes: notes.trim(),
      capo: capo.trim(),
      bpm: bpm,
      tags: tags,
      status: status.trim().isEmpty ? SongStatuses.active : status.trim(),
      referenceFilePath: referenceFilePath?.trim(),
      referenceFileName: referenceFileName?.trim(),
      referenceFileType: referenceFileType?.trim(),
      referenceFileExtension: referenceFileExtension?.trim(),
      referenceFileSizeBytes: referenceFileSizeBytes,
      referenceImportedAt: referenceImportedAt,
      isFavorite: isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

const _draftSentinel = Object();
