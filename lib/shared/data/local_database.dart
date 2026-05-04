import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final fullPath = path.join(databasePath, 'lumen_vesper.db');

    return openDatabase(
      fullPath,
      version: 7,
      onCreate: (db, version) async {
        await _createSongsTable(db);
        await _createSongTagsTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE songs ADD COLUMN capo TEXT NOT NULL DEFAULT ''",
          );
          await db.execute(
            'ALTER TABLE songs ADD COLUMN bpm INTEGER',
          );
          await db.execute(
            "ALTER TABLE songs ADD COLUMN tags TEXT NOT NULL DEFAULT '[]'",
          );
          await db.execute(
            "ALTER TABLE songs ADD COLUMN status TEXT NOT NULL DEFAULT 'Activo'",
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_file_path TEXT',
          );
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_file_name TEXT',
          );
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_file_type TEXT',
          );
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_file_size_bytes INTEGER',
          );
        }
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_file_extension TEXT',
          );
          await db.execute(
            'ALTER TABLE songs ADD COLUMN reference_imported_at TEXT',
          );
        }
        if (oldVersion < 5) {
          await db.execute(
            "ALTER TABLE songs ADD COLUMN genre TEXT NOT NULL DEFAULT ''",
          );
        }
        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE songs ADD COLUMN last_opened_at TEXT',
          );
        }
        if (oldVersion < 7) {
          await _createSongTagsTables(db);
          await _migrateLegacySongTags(db);
        }
      },
    );
  }

  Future<void> _createSongsTable(Database db) async {
    await db.execute('''
      CREATE TABLE songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        lyrics TEXT NOT NULL,
        base_key TEXT NOT NULL,
        author TEXT,
        category TEXT,
        genre TEXT,
        notes TEXT,
        capo TEXT,
        bpm INTEGER,
        tags TEXT NOT NULL DEFAULT '[]',
        status TEXT NOT NULL DEFAULT 'Activo',
        reference_file_path TEXT,
        reference_file_name TEXT,
        reference_file_type TEXT,
        reference_file_extension TEXT,
        reference_file_size_bytes INTEGER,
        reference_imported_at TEXT,
        last_opened_at TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createSongTagsTables(Database db) async {
    await db.execute('''
      CREATE TABLE song_tags(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'personalizada',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE song_tag_links(
        song_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        PRIMARY KEY (song_id, tag_id),
        FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES song_tags(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_song_tags_name_nocase
      ON song_tags(name COLLATE NOCASE)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_song_tag_links_song_id
      ON song_tag_links(song_id)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_song_tag_links_tag_id
      ON song_tag_links(tag_id)
    ''');
  }

  Future<void> _migrateLegacySongTags(Database db) async {
    final rows = await db.query('songs', columns: ['id', 'tags', 'created_at']);
    final tagIdsByName = <String, int>{};

    for (final row in rows) {
      final songId = row['id'] as int?;
      if (songId == null) {
        continue;
      }

      final createdAt =
          row['created_at'] as String? ?? DateTime.now().toIso8601String();
      final labels = _parseLegacyTags(row['tags']);
      for (final label in labels) {
        final normalized = label.toLowerCase();
        var tagId = tagIdsByName[normalized];
        if (tagId == null) {
          final existingRows = await db.query(
            'song_tags',
            columns: ['id'],
            where: 'LOWER(name) = ?',
            whereArgs: [normalized],
            limit: 1,
          );
          if (existingRows.isNotEmpty) {
            tagId = existingRows.first['id'] as int;
          } else {
            tagId = await db.insert('song_tags', {
              'name': label,
              'type': 'personalizada',
              'created_at': createdAt,
              'updated_at': createdAt,
            });
          }
          tagIdsByName[normalized] = tagId;
        }

        await db.insert(
          'song_tag_links',
          {
            'song_id': songId,
            'tag_id': tagId,
            'created_at': createdAt,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
  }

  List<String> _parseLegacyTags(Object? rawValue) {
    if (rawValue is! String || rawValue.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .whereType<String>()
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList();
      }
    } catch (_) {
      return rawValue
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList();
    }

    return const [];
  }
}
