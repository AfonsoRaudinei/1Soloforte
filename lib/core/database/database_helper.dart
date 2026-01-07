import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static const _databaseName = "soloforte.db";
  static const _databaseVersion = 3; // Incremented version to 3

  static const tableVisits = 'visits';
  static const tableAreas = 'areas';
  static const tableOccurrences = 'occurrences';
  static const tableTickets = 'tickets';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    if (kIsWeb) {
      path = _databaseName; // On web, the factory handles the path
    } else {
      path = join(await getDatabasesPath(), _databaseName);
    }

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await _createVisitsTable(db);
    await _createAreasTable(db);
    await _createOccurrencesTable(db);
    await _createTicketsTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration logic
    if (oldVersion < 2) {
      // Old destructive logic for v1->v2 (assumed)
      await db.execute('DROP TABLE IF EXISTS $tableVisits');
      await db.execute('DROP TABLE IF EXISTS $tableAreas');
      await db.execute('DROP TABLE IF EXISTS $tableOccurrences');
      await _createVisitsTable(db);
      await _createAreasTable(db);
      await _createOccurrencesTable(db);
    }

    if (oldVersion < 3) {
      await _createTicketsTable(db);
    }
  }

  Future _createVisitsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableVisits (
        id TEXT PRIMARY KEY,
        check_in_time INTEGER NOT NULL,
        status TEXT NOT NULL,
        is_dirty INTEGER NOT NULL DEFAULT 0,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createAreasTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableAreas (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        status TEXT NOT NULL,
        is_dirty INTEGER NOT NULL DEFAULT 0,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createOccurrencesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableOccurrences (
        id TEXT PRIMARY KEY,
        area_name TEXT NOT NULL,
        date INTEGER NOT NULL,
        status TEXT NOT NULL,
        is_dirty INTEGER NOT NULL DEFAULT 0,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createTicketsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableTickets (
        id TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
  }
}
