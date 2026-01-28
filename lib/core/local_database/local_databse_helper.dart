import 'package:healthcare/core/local_database/local_datebase_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Represents a column definition for a database table
class ColumnDefinition {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNullable;

  const ColumnDefinition({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isAutoIncrement = false,
    this.isNullable = true,
  });

  String toSql() {
    final buffer = StringBuffer();
    buffer.write('$name $type');

    if (isPrimaryKey) {
      buffer.write(' PRIMARY KEY');
    }
    if (isAutoIncrement) {
      buffer.write(' AUTOINCREMENT');
    }
    if (!isNullable && !isPrimaryKey) {
      buffer.write(' NOT NULL');
    }

    return buffer.toString();
  }
}

/// Represents a table schema definition
class TableSchema {
  final String tableName;
  final List<ColumnDefinition> columns;

  const TableSchema({required this.tableName, required this.columns});

  String createTableSql() {
    final columnsDefinition = columns
        .map((col) => col.toSql())
        .join(',\n        ');
    return '''
      CREATE TABLE $tableName (
        $columnsDefinition
      )
    ''';
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Define all table schemas here
  static final List<TableSchema> _tableSchemas = [
    // Patient Table Schema
    TableSchema(
      tableName: DatabaseConstants.patientTable,
      columns: [
        const ColumnDefinition(
          name: DatabaseConstants.columnId,
          type: 'INTEGER',
          isPrimaryKey: true,
          isAutoIncrement: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnGender,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnBirthDate,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnPhone,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmail,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnAddress,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnBloodType,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactPhone,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactAlternativePhone,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactRelationship,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactAddress,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnChronicConditions,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnAllergies,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnCurrentMedications,
          type: 'TEXT',
          isNullable: true,
        ),
      ],
    ),

    // Medicine Table Schema
    TableSchema(
      tableName: DatabaseConstants.medicineTable,
      columns: [
        const ColumnDefinition(
          name: DatabaseConstants.medicineId,
          type: 'TEXT',
          isPrimaryKey: true,
          isAutoIncrement: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicinePatientId,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineDrugName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineDescription,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineTimesToTake,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineTags,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineCreatedAt,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineUpdatedAt,
          type: 'TEXT',
          isNullable: true,
        ),
      ],
    ),

    // Add more table schemas here as needed...
  ];

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
      onCreate: _createAllTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates all tables defined in [_tableSchemas]
  Future<void> _createAllTables(Database db, int version) async {
    for (final schema in _tableSchemas) {
      await db.execute(schema.createTableSql());
    }
  }

  /// Creates a single table from a [TableSchema]
  Future<void> createTable(TableSchema schema) async {
    final db = await database;
    await db.execute(schema.createTableSql());
  }

  /// Creates a single table by name if it exists in [_tableSchemas]
  Future<void> createTableByName(String tableName) async {
    final schema = _tableSchemas.firstWhere(
      (s) => s.tableName == tableName,
      orElse: () => throw Exception('Table schema not found for: $tableName'),
    );
    await createTable(schema);
  }

  /// Check if a table exists in the database
  Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  /// Get all registered table names
  List<String> get registeredTableNames =>
      _tableSchemas.map((s) => s.tableName).toList();

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Example migration strategies:
      // 1. Add new tables that don't exist
      // 2. Alter existing tables with new columns
      // 3. Migrate data between versions

      // For example, to add new tables in a new version:
      // for (final schema in _tableSchemas) {
      //   final exists = await db.rawQuery(
      //     "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      //     [schema.tableName],
      //   );
      //   if (exists.isEmpty) {
      //     await db.execute(schema.createTableSql());
      //   }
      // }
    }
  }

  /// Drops a table by name
  Future<void> dropTable(String tableName) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  /// Drops all tables and recreates them
  Future<void> resetDatabase() async {
    final db = await database;
    for (final schema in _tableSchemas) {
      await db.execute('DROP TABLE IF EXISTS ${schema.tableName}');
    }
    await _createAllTables(db, DatabaseConstants.databaseVersion);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
