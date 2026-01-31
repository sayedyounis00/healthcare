import 'package:dartz/dartz.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_local_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../models/patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientLocalDataSource localDataSource;
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, int>> addPatient(Patient patient) async {
    try {
      final patientModel = PatientModel.fromEntity(patient);
      final id = await localDataSource.insertPatient(patientModel);
      final remotePatientModel = patientModel.copyWith(id: id);
      await remoteDataSource.insertPatient(
        remotePatientModel,DatabaseConstants.patientTable);
      return Right(id);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Patient?>> getPatient(int id) async {
    try {
      final patient = await localDataSource.getPatient(id);
      await remoteDataSource.getPatientById(id,DatabaseConstants.patientTable);
      return Right(patient);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updatePatient(Patient patient) async {
    try {
      final patientModel = PatientModel.fromEntity(patient);
      final count = await localDataSource.updatePatient(patientModel);
      await remoteDataSource.updatePatient(PatientModel.fromEntity(patient),DatabaseConstants.patientTable);
      return Right(count);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deletePatient(int id) async {
    try {
      final count = await localDataSource.deletePatient(id);
      await remoteDataSource.deletePatient(id,DatabaseConstants.patientTable);
      return Right(count);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }
}
