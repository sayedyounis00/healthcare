import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/sync/datasource/sync_queue_local_datasource.dart';
import 'package:healthcare/core/sync/models/sync_queue_model.dart';
import 'package:healthcare/core/utils/network_info.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_remote_datasource.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

class SyncManager {
  final SyncQueueLocalDataSource syncQueueDataSource;
  final MedicineRemoteDataSource medicineRemoteDataSource;
  final NetworkInfo networkInfo;

  Timer? _syncTimer;
  Timer? _connectivityTimer;
  bool _isSyncing = false;
  bool _lastConnectionStatus = true;
  static const int maxRetryAttempts = 3;
  static const Duration syncInterval = Duration(minutes: 1);
  static const Duration connectivityCheckInterval = Duration(seconds: 5);

  SyncManager({
    required this.syncQueueDataSource,
    required this.medicineRemoteDataSource,
    NetworkInfo? networkInfo,
  }) : networkInfo = networkInfo ?? NetworkInfo();

  void startPeriodicSync() {
    _syncTimer?.cancel();
    _connectivityTimer?.cancel();

    _syncTimer = Timer.periodic(syncInterval, (_) => syncPendingOperations());

    _connectivityTimer = Timer.periodic(connectivityCheckInterval, (_) async {
      final isConnected = await networkInfo.isConnected;
      if (isConnected && !_lastConnectionStatus) {
        debugPrint(
          '🌐 Internet connection restored! Triggering immediate sync...',
        );
        await syncPendingOperations();
      }
      _lastConnectionStatus = isConnected;
    });

    debugPrint(
      '🔄 Started periodic sync (interval: ${syncInterval.inMinutes} minutes, connectivity check: ${connectivityCheckInterval.inSeconds}s)',
    );

    syncPendingOperations();
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _connectivityTimer?.cancel();
    _syncTimer = null;
    _connectivityTimer = null;
    debugPrint('⏹️ Stopped periodic sync');
  }

  Future<void> syncPendingOperations() async {
    if (_isSyncing) {
      debugPrint('⚠️ Sync already in progress, skipping...');
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      debugPrint('📴 No internet connection, skipping sync');
      return;
    }

    _isSyncing = true;
    debugPrint('🔄 Starting sync of pending operations...');

    try {
      final pendingSyncs = await syncQueueDataSource.getPendingSyncs();

      if (pendingSyncs.isEmpty) {
        debugPrint('✅ No pending syncs found');
        _isSyncing = false;
        return;
      }

      debugPrint('📋 Found ${pendingSyncs.length} pending sync operations');

      for (final syncItem in pendingSyncs) {
        await _processSyncItem(syncItem);
      }

      debugPrint('✅ Sync completed');
    } catch (e) {
      debugPrint('❌ Error during sync: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processSyncItem(SyncQueueModel syncItem) async {
    try {
      debugPrint(
        '🔄 Processing sync: ${syncItem.operation} for ${syncItem.tableName} (recordId: ${syncItem.recordId})',
      );

      switch (syncItem.tableName) {
        case DatabaseConstants.medicineTable:
          await _syncMedicine(syncItem);
          break;
        default:
          debugPrint('⚠️ Unknown table: ${syncItem.tableName}');
          await syncQueueDataSource.removeFromQueue(syncItem.id!);
      }
    } catch (e) {
      final newRetryCount = syncItem.retryCount + 1;
      final errorMessage = e.toString();

      if (newRetryCount >= maxRetryAttempts) {
        debugPrint(
          '❌ Max retry attempts reached for sync item ${syncItem.id}, removing from queue',
        );
        await syncQueueDataSource.removeFromQueue(syncItem.id!);
      } else {
        debugPrint('⚠️ Sync failed, retry count: $newRetryCount');
        await syncQueueDataSource.updateRetryCount(
          syncItem.id!,
          newRetryCount,
          errorMessage,
        );
      }
    }
  }

  Future<void> _syncMedicine(SyncQueueModel syncItem) async {
    final data = syncItem.getDataAsMap();
    final medicine = MedicineModel.fromJson(data);

    switch (syncItem.operation) {
      case DatabaseConstants.syncOperationInsert:
        await medicineRemoteDataSource.insertMedicine(medicine);
        break;
      case DatabaseConstants.syncOperationUpdate:
        await medicineRemoteDataSource.updateMedicine(medicine);
        break;
      case DatabaseConstants.syncOperationDelete:
        await medicineRemoteDataSource.deleteMedicine(syncItem.recordId);
        break;
      default:
        throw SyncException('Unknown operation: ${syncItem.operation}');
    }

    await syncQueueDataSource.removeFromQueue(syncItem.id!);
    debugPrint(
      '✅ Successfully synced: ${syncItem.operation} for medicine ${medicine.drugName}',
    );
  }

  Future<int> queueSync({
    required String tableName,
    required String operation,
    required Map<String, dynamic> data,
    required int recordId,
  }) async {
    final syncItem = SyncQueueModel.create(
      tableName: tableName,
      operation: operation,
      data: data,
      recordId: recordId,
    );

    final id = await syncQueueDataSource.addToQueue(syncItem);
    debugPrint(
      '📥 Queued $operation for $tableName (local id: $recordId, queue id: $id)',
    );
    return id;
  }

  Future<int> getPendingSyncCount() async {
    return await syncQueueDataSource.getPendingCount();
  }

  void dispose() {
    stopPeriodicSync();
  }
}
