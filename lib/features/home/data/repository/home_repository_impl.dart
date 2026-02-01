import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:healthcare/features/home/data/datasource/home_local_datasource.dart';
import 'package:healthcare/features/home/domain/repository/home_repository.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PatientModel?>> getPatient(int id) async {
    try {
      final patient = await localDataSource.getPatient(id);
      return Right(patient);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get patient: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MedicineModel>>> getMedicinesByPatientId(
    int patientId,
  ) async {
    try {
      final medicines = await localDataSource.getMedicinesByPatientId(
        patientId,
      );
      return Right(medicines);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get medicines: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getAppointmentsByPatientId(
    int patientId,
  ) async {
    try {
      final appointments = await localDataSource.getAppointmentsByPatientId(
        patientId,
      );
      return Right(appointments);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get appointments: $e'));
    }
  }

  @override
  Future<Either<Failure, MedicineModel?>> getNextMedicine(int patientId) async {
    try {
      final medicine = await localDataSource.getNextMedicine(patientId);
      return Right(medicine);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get next medicine: $e'));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel?>> getNextAppointment(
    int patientId,
  ) async {
    try {
      final appointment = await localDataSource.getNextAppointment(patientId);
      return Right(appointment);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get next appointment: $e'));
    }
  }
}
