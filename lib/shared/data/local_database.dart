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
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE songs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            lyrics TEXT NOT NULL,
            base_key TEXT NOT NULL,
            author TEXT,
            category TEXT,
            notes TEXT,
            capo TEXT,
            bpm INTEGER,
            tags TEXT NOT NULL DEFAULT '[]',
            status TEXT NOT NULL DEFAULT 'Activo',
            reference_file_path TEXT,
            reference_file_name TEXT,
            reference_file_type TEXT,
            reference_file_size_bytes INTEGER,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
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
      },
    );
  }
}
