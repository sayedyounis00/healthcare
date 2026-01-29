import 'package:flutter/widgets.dart';
import 'package:healthcare/core/config/env_config.dart';
import 'package:healthcare/core/di/injection.dart' as di;
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeEnvironment();
    await _initializeSupabase();
    await _initializeDependencyInjection();
    await _printDatabaseTables();
  }

  //===to get data from .env file===\\
  static Future<void> _initializeEnvironment() async {
    try {
      await EnvConfig.init();
      debugPrint('Environment variables loaded');
    } catch (e) {
      debugPrint('Error loading environment: $e');
      rethrow;
    }
  }

  static Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      rethrow;
    }
  }

  static Future<void> _initializeDependencyInjection() async {
    try {
      await di.setUp();
    } catch (e) {
      debugPrint('Error initializing DI: $e');
      rethrow;
    }
  }

  static Future<void> _printDatabaseTables() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_%'",
      );

      debugPrint('--- Database Schema ---');
      if (tables.isEmpty) {
        debugPrint('No tables found');
      } else {
        for (final table in tables) {
          final name = table['name'] as String;
          final count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $name'),
          );
          debugPrint('Table: $name | Rows: $count');
        }
      }
      debugPrint('Total tables: ${tables.length}');
      debugPrint('-----------------------');
    } catch (e) {
      debugPrint('Error printing tables: $e');
    }
  }
}
