import 'package:flutter/foundation.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/sync/models/sync_queue_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class SyncQueueLocalDataSource {
  Future<int> addToQueue(SyncQueueModel syncItem);
  Future<List<SyncQueueModel>> getPendingSyncs();
  Future<List<SyncQueueModel>> getPendingSyncsByTable(String tableName);
  Future<int> removeFromQueue(int id);
  Future<int> updateRetryCount(int id, int retryCount, String? error);
  Future<void> clearQueue();
  Future<int> getPendingCount();
}

class SyncQueueLocalDataSourceImpl implements SyncQueueLocalDataSource {
  final LocalDatabaseHelper databaseHelper;
  bool _tableChecked = false;

  SyncQueueLocalDataSourceImpl({required this.databaseHelper});

  Future<void> _ensureTableExists() async {
    if (_tableChecked) return;
    try {
      final isExist = await databaseHelper.tableExists(
        DatabaseConstants.syncQueueTable,
      );
      if (!isExist) {
        await databaseHelper.createTableByName(
          DatabaseConstants.syncQueueTable,
        );
        debugPrint('✅ Created sync_queue table');
      }
      _tableChecked = true;
    } catch (e) {
      debugPrint('❌ Failed to ensure sync_queue table exists: $e');
      rethrow;
    }
  }

  @override
  Future<int> addToQueue(SyncQueueModel syncItem) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final map = syncItem.toMap();
      map.remove(DatabaseConstants.syncId);
      final id = await db.insert(
        DatabaseConstants.syncQueueTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint(
        '✅ Added to sync queue: ${syncItem.operation} for ${syncItem.tableName} (id: $id)',
      );
      return id;
    } catch (e) {
      throw LocalDatabaseException('Failed to add to sync queue: $e');
    }
  }

  @override
  Future<List<SyncQueueModel>> getPendingSyncs() async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> results = await db.query(
        DatabaseConstants.syncQueueTable,
        orderBy: '${DatabaseConstants.syncCreatedAt} ASC',
      );
      return results.map((e) => SyncQueueModel.fromMap(e)).toList();
    } catch (e) {
      throw LocalDatabaseException('Failed to get pending syncs: $e');
    }
  }

  @override
  Future<List<SyncQueueModel>> getPendingSyncsByTable(String tableName) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> results = await db.query(
        DatabaseConstants.syncQueueTable,
        where: '${DatabaseConstants.syncTableName} = ?',
        whereArgs: [tableName],
        orderBy: '${DatabaseConstants.syncCreatedAt} ASC',
      );
      return results.map((e) => SyncQueueModel.fromMap(e)).toList();
    } catch (e) {
      throw LocalDatabaseException('Failed to get pending syncs: $e');
    }
  }

  @override
  Future<int> removeFromQueue(int id) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final rowsAffected = await db.delete(
        DatabaseConstants.syncQueueTable,
        where: '${DatabaseConstants.syncId} = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Removed from sync queue: id $id');
      return rowsAffected;
    } catch (e) {
      throw LocalDatabaseException('Failed to remove from sync queue: $e');
    }
  }

  @override
  Future<int> updateRetryCount(int id, int retryCount, String? error) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final rowsAffected = await db.update(
        DatabaseConstants.syncQueueTable,
        {
          DatabaseConstants.syncRetryCount: retryCount,
          DatabaseConstants.syncLastError: error,
        },
        where: '${DatabaseConstants.syncId} = ?',
        whereArgs: [id],
      );
      return rowsAffected;
    } catch (e) {
      throw LocalDatabaseException('Failed to update retry count: $e');
    }
  }

  @override
  Future<void> clearQueue() async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      await db.delete(DatabaseConstants.syncQueueTable);
      debugPrint('✅ Cleared sync queue');
    } catch (e) {
      throw LocalDatabaseException('Failed to clear sync queue: $e');
    }
  }

  @override
  Future<int> getPendingCount() async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${DatabaseConstants.syncQueueTable}',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw LocalDatabaseException('Failed to get pending count: $e');
    }
  }
}
