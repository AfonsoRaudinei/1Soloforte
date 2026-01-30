import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "soloforte.db";

  static const tableVisits = 'visits';
  static const tableAreas = 'areas';
  static const tableOccurrences = 'occurrences';
  static const tableTickets = 'tickets';
  static const tableMarketingPosts = 'marketing_posts';
  static const tableMarketingPlans = 'marketing_plans';
  static const tableMarketingPublications = 'marketing_publications';
  static const tableTechnicalReports = 'technical_reports';
  static const tableClients = 'clients';
  static const tableAgendaEvents = 'agenda_events';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseVersion = 9; // Incremented version to 9

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
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
    await _createMarketingPostsTable(db);
    await _createMarketingPlansTable(db);
    await _createMarketingPublicationsTable(db);
    await _createTechnicalReportsTable(db);
    await _createClientsTable(db);
    await _createAgendaEventsTable(db);
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

    if (oldVersion < 4) {
      await _createMarketingPostsTable(db);
    }

    if (oldVersion < 5) {
      await _createClientsTable(db);
    }

    if (oldVersion < 6) {
      await _createAgendaEventsTable(db);
    }

    if (oldVersion < 7) {
      await _createMarketingPlansTable(db);
    }

    if (oldVersion < 8) {
      await _createMarketingPublicationsTable(db);
    }

    if (oldVersion < 9) {
      await _createTechnicalReportsTable(db);
    }
  }

  Future _createTechnicalReportsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableTechnicalReports (
        id TEXT PRIMARY KEY,
        visit_id TEXT NOT NULL,
        client_id TEXT NOT NULL,
        generated_at INTEGER NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
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

  Future _createMarketingPostsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableMarketingPosts (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createMarketingPlansTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableMarketingPlans (
        level TEXT PRIMARY KEY,
        description TEXT,
        price REAL NOT NULL,
        unit TEXT NOT NULL,
        active INTEGER NOT NULL
      )
    ''');
  }

  Future _createClientsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableClients (
        id TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        updated_at INTEGER NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createAgendaEventsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableAgendaEvents (
        id TEXT PRIMARY KEY,
        start_time INTEGER NOT NULL,
        status TEXT NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
  }

  Future _createMarketingPublicationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableMarketingPublications (
        id TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL,
        json_data TEXT NOT NULL
      )
    ''');
  }
}
