// lib/features/patient/domain/repositories/patient_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient.dart';

abstract class PatientRepository {
  Future<Either<Failure, int>> addPatient(Patient patient);
  Future<Either<Failure, Patient?>> getPatient(int id);
  Future<Either<Failure, int>> updatePatient(Patient patient);
  Future<Either<Failure, int>> deletePatient(int id);
}