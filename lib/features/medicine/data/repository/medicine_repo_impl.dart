import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/sync/sync_manager.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_local_datasource.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_remote_datasource.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:healthcare/features/medicine/domain/entities/medicine.dart';
import 'package:healthcare/features/medicine/domain/repository/medicine_repository.dart';

class MedicineRepoImpl extends MedicineRepository {
  final MedicineLocalDataSource medicineLocalDataSource;
  final MedicineRemoteDataSource medicineRemoteDataSource;
  final SyncManager syncManager;

  MedicineRepoImpl({
    required this.medicineLocalDataSource,
    required this.medicineRemoteDataSource,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, int>> addMedicine(Medicine medicine) async {
    try {
      // Step 1: Save to local database (always works offline)
      final medicineModel = MedicineModel.fromEntity(medicine);
      final id = await medicineLocalDataSource.insertMedicine(medicineModel);
      debugPrint('✅ Medicine saved locally with id: $id');

      // Step 2: Try to sync to remote
      final remoteMedicineModel = medicineModel.copyWith(id: id);
      try {
        await medicineRemoteDataSource.insertMedicine(remoteMedicineModel);
        debugPrint('✅ Medicine synced to remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint('📴 No internet, queuing medicine for sync ${e.toString()}');
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationInsert,
          data: remoteMedicineModel.toJson(),
          recordId: id,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint('⚠️ Server error, queuing medicine for retry: ${e.message}');
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationInsert,
          data: remoteMedicineModel.toJson(),
          recordId: id,
        );
      }

      return Right(id);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medicine>>> getMedicineBypatientId(
    int patientId,
  ) async {
    try {
      // Step 1: Get from local database (always works)
      final allmedicine = await medicineLocalDataSource.getMedicinesByPatientId(
        patientId,
      );
      debugPrint('✅ Retrieved ${allmedicine.length} medicines from local');

      // Step 2: Try to get from remote (optional, for sync purposes)
      try {
        await medicineRemoteDataSource.getMedicinesByPatientId(patientId);
        debugPrint('✅ Fetched from remote for sync check');
      } on NetworkException catch (e) {
        debugPrint('📴 No internet, using local data only ${e.toString()}');
      } on ServerException catch (e) {
        debugPrint('⚠️ Server error, using local data only: ${e.message}');
      }

      return Right(allmedicine);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateMedicine(Medicine medicine) async {
    try {
      // Step 1: Update local database (always works offline)
      final medicineModel = MedicineModel.fromEntity(medicine);
      final result = await medicineLocalDataSource.updateMedicine(
        medicineModel,
      );
      debugPrint('✅ Medicine updated locally: ${medicine.drugName}');

      // Step 2: Try to sync to remote
      try {
        await medicineRemoteDataSource.updateMedicine(medicineModel);
        debugPrint('✅ Medicine synced to remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint('📴 No internet, queuing medicine update for sync ${e.toString()}');
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationUpdate,
          data: medicineModel.toJson(),
          recordId: medicine.id!,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint(
          '⚠️ Server error, queuing medicine update for retry: ${e.message}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationUpdate,
          data: medicineModel.toJson(),
          recordId: medicine.id!,
        );
      }

      return Right(result);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteMedicine(int id) async {
    try {
      // Step 1: Delete from local database (always works offline)
      final result = await medicineLocalDataSource.deleteMedicine(id);
      debugPrint('✅ Medicine deleted locally: id $id');

      // Step 2: Try to sync to remote
      try {
        await medicineRemoteDataSource.deleteMedicine(id);
        debugPrint('✅ Medicine deleted from remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint('📴 No internet, queuing medicine delete for sync ${e.toString()}');
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationDelete,
          data: {'id': id},
          recordId: id,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint(
          '⚠️ Server error, queuing medicine delete for retry: ${e.message}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.medicineTable,
          operation: DatabaseConstants.syncOperationDelete,
          data: {'id': id},
          recordId: id,
        );
      }

      return Right(result);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  /// Get count of pending sync operations
  Future<int> getPendingSyncCount() async {
    return await syncManager.getPendingSyncCount();
  }

  /// Manually trigger sync of pending operations
  Future<void> syncPendingOperations() async {
    await syncManager.syncPendingOperations();
  }
}
