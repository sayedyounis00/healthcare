import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/sync/sync_manager.dart';
import 'package:healthcare/features/Appointments/data/datasource/appointment_local_datasource.dart';
import 'package:healthcare/features/Appointments/data/datasource/appointment_remote_datasource.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/Appointments/domain/entites/appoinment.dart';
import 'package:healthcare/features/Appointments/domain/repository/appointment_repo.dart';

class AppointmentRepoImpl extends AppointmentRepository {
  final AppointmentLocalDatasource appointmentLocalDatasource;
  final AppointmentRemoteDataSource appointmentRemoteDataSource;
  final SyncManager syncManager;

  AppointmentRepoImpl({
    required this.appointmentLocalDatasource,
    required this.appointmentRemoteDataSource,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, int>> addAppointment(Appointment appointment) async {
    try {
      // Step 1: Save to local database (always works offline)
      final appointmentModel = AppointmentModel.fromEntity(appointment);
      await appointmentLocalDatasource.insertAppointment(appointmentModel);
      final id = appointmentModel.id ?? 0;
      debugPrint('✅ Appointment saved locally with id: $id');

      // Step 2: Try to sync to remote
      final remoteAppointmentModel = appointmentModel.copyWith(id: id);
      try {
        await appointmentRemoteDataSource.insertAppointment(
          remoteAppointmentModel,
        );
        debugPrint('✅ Appointment synced to remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint(
          '📴 No internet, queuing appointment for sync ${e.toString()}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
          operation: DatabaseConstants.syncOperationInsert,
          data: remoteAppointmentModel.toJson(),
          recordId: id,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint(
          '⚠️ Server error, queuing appointment for retry: ${e.message}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
          operation: DatabaseConstants.syncOperationInsert,
          data: remoteAppointmentModel.toJson(),
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
  Future<Either<Failure, List<Appointment>>> getAppointmentsByPatientId(
    int patientId,
  ) async {
    try {
      // Step 1: Get from local database (always works)
      final allAppointments = await appointmentLocalDatasource
          .getAllAppointment(patientId);
      debugPrint(
        '✅ Retrieved ${allAppointments.length} appointments from local',
      );

      // Step 2: Try to get from remote (optional, for sync purposes)
      try {
        await appointmentRemoteDataSource.getAppointmentsByPatientId(patientId);
        debugPrint('✅ Fetched from remote for sync check');
      } on NetworkException catch (e) {
        debugPrint('📴 No internet, using local data only ${e.toString()}');
      } on ServerException catch (e) {
        debugPrint('⚠️ Server error, using local data only: ${e.message}');
      }

      return Right(allAppointments);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateAppointment(
    Appointment appointment,
  ) async {
    try {
      // Step 1: Update local database (always works offline)
      final appointmentModel = AppointmentModel.fromEntity(appointment);
      final result = await appointmentLocalDatasource.updateAppointment(
        appointmentModel,
      );
      debugPrint('✅ Appointment updated locally: ${appointment.doctorName}');

      // Step 2: Try to sync to remote
      try {
        await appointmentRemoteDataSource.updateAppointment(appointmentModel);
        debugPrint('✅ Appointment synced to remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint(
          '📴 No internet, queuing appointment update for sync ${e.toString()}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
          operation: DatabaseConstants.syncOperationUpdate,
          data: appointmentModel.toJson(),
          recordId: appointment.id!,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint(
          '⚠️ Server error, queuing appointment update for retry: ${e.message}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
          operation: DatabaseConstants.syncOperationUpdate,
          data: appointmentModel.toJson(),
          recordId: appointment.id!,
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
  Future<Either<Failure, int>> deleteAppointment(int id) async {
    try {
      // Step 1: Delete from local database (always works offline)
      final result = await appointmentLocalDatasource.deleteAppointment(id);
      debugPrint('✅ Appointment deleted locally: id $id');

      // Step 2: Try to sync to remote
      try {
        await appointmentRemoteDataSource.deleteAppointment(id);
        debugPrint('✅ Appointment deleted from remote successfully');
      } on NetworkException catch (e) {
        // No internet - queue for later sync
        debugPrint(
          '📴 No internet, queuing appointment delete for sync ${e.toString()}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
          operation: DatabaseConstants.syncOperationDelete,
          data: {'id': id},
          recordId: id,
        );
      } on ServerException catch (e) {
        // Server error - queue for retry
        debugPrint(
          '⚠️ Server error, queuing appointment delete for retry: ${e.message}',
        );
        await syncManager.queueSync(
          tableName: DatabaseConstants.appoinmentTable,
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
