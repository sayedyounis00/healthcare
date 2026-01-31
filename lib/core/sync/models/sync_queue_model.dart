import 'dart:convert';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';

class SyncQueueModel {
  final int? id;
  final String tableName;
  final String operation; // insert, update, delete
  final String data; 
  final int recordId;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  SyncQueueModel({
    this.id,
    required this.tableName,
    required this.operation,
    required this.data,
    required this.recordId,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DatabaseConstants.syncId: id,
      DatabaseConstants.syncTableName: tableName,
      DatabaseConstants.syncOperation: operation,
      DatabaseConstants.syncData: data,
      DatabaseConstants.syncRecordId: recordId,
      DatabaseConstants.syncCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.syncRetryCount: retryCount,
      DatabaseConstants.syncLastError: lastError,
    };
  }

  factory SyncQueueModel.fromMap(Map<String, dynamic> map) {
    return SyncQueueModel(
      id: map[DatabaseConstants.syncId] as int?,
      tableName: map[DatabaseConstants.syncTableName] as String,
      operation: map[DatabaseConstants.syncOperation] as String,
      data: map[DatabaseConstants.syncData] as String,
      recordId: map[DatabaseConstants.syncRecordId] as int,
      createdAt: DateTime.parse(map[DatabaseConstants.syncCreatedAt] as String),
      retryCount: map[DatabaseConstants.syncRetryCount] as int? ?? 0,
      lastError: map[DatabaseConstants.syncLastError] as String?,
    );
  }

  SyncQueueModel copyWith({
    int? id,
    String? tableName,
    String? operation,
    String? data,
    int? recordId,
    DateTime? createdAt,
    int? retryCount,
    String? lastError,
  }) {
    return SyncQueueModel(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      recordId: recordId ?? this.recordId,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  static SyncQueueModel create({
    required String tableName,
    required String operation,
    required Map<String, dynamic> data,
    required int recordId,
  }) {
    return SyncQueueModel(
      tableName: tableName,
      operation: operation,
      data: jsonEncode(data),
      recordId: recordId,
      createdAt: DateTime.now(),
      retryCount: 0,
    );
  }

  Map<String, dynamic> getDataAsMap() {
    return jsonDecode(data) as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'SyncQueueModel(id: $id, table: $tableName, operation: $operation, recordId: $recordId, retryCount: $retryCount)';
  }
}
