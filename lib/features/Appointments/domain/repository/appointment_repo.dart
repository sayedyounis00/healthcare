import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/Appointments/domain/entites/appoinment.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, int>> addAppointment(Appointment appointment);
  Future<Either<Failure, List<Appointment>>> getAppointmentsByPatientId(
    int patientId,
  );
  Future<Either<Failure, int>> updateAppointment(Appointment appointment);
  Future<Either<Failure, int>> deleteAppointment(int id);
}
