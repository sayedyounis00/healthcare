import 'package:flutter/foundation.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/localDatabase/tabel_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ColumnDefinition {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNullable;
  final String? references;

  const ColumnDefinition({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isAutoIncrement = false,
    this.isNullable = true,
    this.references,
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
    if (references != null) {
      buffer.write(' REFERENCES $references');
    }

    return buffer.toString();
  }
}

class GeneratedTableSchema {
  final String tableName;
  final List<ColumnDefinition> columns;

  const GeneratedTableSchema({required this.tableName, required this.columns});

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
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createAllTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createAllTables(Database db, int version) async {
    for (final schema in TabelSchema.tableSchemas) {
      await db.execute(schema.createTableSql());
    }
  }

  Future<void> createTable(GeneratedTableSchema schema) async {
    final db = await database;
    await db.execute(schema.createTableSql());
  }

  Future<void> createTableByName(String tableName) async {
    final schema = TabelSchema.tableSchemas.firstWhere(
      (s) => s.tableName == tableName,
      orElse: () => throw Exception('Table schema not found for: $tableName'),
    );
    await createTable(schema);
  }

  Future<bool> tableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  //getting tables created
  List<String> get registeredTableNames =>
      TabelSchema.tableSchemas.map((s) => s.tableName).toList();

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (final schema in TabelSchema.tableSchemas) {
      final exists = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [schema.tableName],
      );
      if (exists.isEmpty) {
        await db.execute(schema.createTableSql());
        debugPrint('✅ Created table ${schema.tableName} during upgrade');
      }
    }
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS medicine_data');
    }
  }

  Future<void> dropTable(String tableName) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  Future<void> resetDatabase() async {
    final db = await database;
    for (final schema in TabelSchema.tableSchemas) {
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
