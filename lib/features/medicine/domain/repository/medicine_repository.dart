import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/medicine/domain/entities/medicine.dart';

abstract class MedicineRepository {
  Future<Either<Failure, int>> addMedicine(Medicine medicine);
  Future<Either<Failure, List<Medicine>>> getMedicineBypatientId(int id);
  Future<Either<Failure, int>> updateMedicine(Medicine medicine);
  Future<Either<Failure, int>> deleteMedicine(int id);
}
