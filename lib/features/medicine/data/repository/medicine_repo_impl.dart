import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_local_datasource.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:healthcare/features/medicine/domain/entities/medicine.dart';
import 'package:healthcare/features/medicine/domain/repository/medicine_repository.dart';

class MedicineRepoImpl extends MedicineRepository {
  final MedicineLocalDataSource medicineLocalDataSource;

  MedicineRepoImpl({required this.medicineLocalDataSource});
  @override
  Future<Either<Failure, int>> addMedicine(Medicine medicine) async {
    try {
      final medicineModel = MedicineModel.fromEntity(medicine);
      final id = await medicineLocalDataSource.insertMedicine(medicineModel);
      return Right(id);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medicine>>> getMedicine(int id) async {
    try {
      final allmedicine = await medicineLocalDataSource.getMedicine(id) ?? [];
      return Right(allmedicine);
    } on LocalDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteMedicine(int id) {
    // TODO: implement deleteMedicine
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> updateMedicine(Medicine medicine) {
    // TODO: implement updateMedicine
    throw UnimplementedError();
  }
}
