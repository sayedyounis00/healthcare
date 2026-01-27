import 'package:healthcare/core/local_database/local_datebase_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.patientTable} (
        ${DatabaseConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.columnName} TEXT NOT NULL,
        ${DatabaseConstants.columnGender} TEXT NOT NULL,
        ${DatabaseConstants.columnBirthDate} TEXT NOT NULL,
        ${DatabaseConstants.columnPhone} TEXT NOT NULL,
        ${DatabaseConstants.columnEmail} TEXT NOT NULL,
        ${DatabaseConstants.columnAddress} TEXT NOT NULL,
        ${DatabaseConstants.columnBloodType} TEXT NOT NULL,
        ${DatabaseConstants.columnEmergencyContactName} TEXT NOT NULL,
        ${DatabaseConstants.columnEmergencyContactPhone} TEXT NOT NULL,
        ${DatabaseConstants.columnEmergencyContactAlternativePhone} TEXT,
        ${DatabaseConstants.columnEmergencyContactRelationship} TEXT NOT NULL,
        ${DatabaseConstants.columnEmergencyContactAddress} TEXT NOT NULL,
        ${DatabaseConstants.columnChronicConditions} TEXT,
        ${DatabaseConstants.columnAllergies} TEXT,
        ${DatabaseConstants.columnCurrentMedications} TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example: Add new columns, create new tables, etc.
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}