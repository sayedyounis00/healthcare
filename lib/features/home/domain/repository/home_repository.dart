import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, PatientModel?>> getPatient(int id);
  Future<Either<Failure, List<MedicineModel>>> getMedicinesByPatientId(
    int patientId,
  );
  Future<Either<Failure, List<AppointmentModel>>> getAppointmentsByPatientId(
    int patientId,
  );
  Future<Either<Failure, MedicineModel?>> getNextMedicine(int patientId);
  Future<Either<Failure, AppointmentModel?>> getNextAppointment(int patientId);
}
