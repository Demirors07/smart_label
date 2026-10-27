import 'database_seeder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static const String _databaseName = 'smart_label.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databaseDirectory = await getDatabasesPath();

    final databasePath = join(databaseDirectory, _databaseName);

    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        canonical_name TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredient_search_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL,
        search_term TEXT NOT NULL,
        normalized_term TEXT NOT NULL,
        FOREIGN KEY (ingredient_id)
          REFERENCES ingredients(id)
          ON DELETE CASCADE,
        UNIQUE (ingredient_id, normalized_term)
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        category_name TEXT NOT NULL,
        type TEXT NOT NULL
          CHECK (type IN ('ALLERGEN', 'DIET')),
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredient_category_mappings (
        ingredient_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        risk_level TEXT NOT NULL
          CHECK (
            risk_level IN (
              'WARNING',
              'INCOMPATIBLE'
            )
          ),
        PRIMARY KEY (ingredient_id, category_id),
        FOREIGN KEY (ingredient_id)
          REFERENCES ingredients(id)
          ON DELETE CASCADE,
        FOREIGN KEY (category_id)
          REFERENCES categories(id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL UNIQUE,
        is_enabled INTEGER NOT NULL DEFAULT 0
          CHECK (is_enabled IN (0, 1)),
        FOREIGN KEY (category_id)
          REFERENCES categories(id)
          ON DELETE CASCADE
      )
    ''');
    await DatabaseSeeder.seed(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future database migrations will be implemented here.
  }
}
