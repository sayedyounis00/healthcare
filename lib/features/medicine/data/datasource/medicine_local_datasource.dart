import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/local_database/local_databse_helper.dart';
import 'package:healthcare/core/local_database/local_datebase_constants.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class MedicineLocalDataSource {
  Future<int> insertMedicine(MedicineModel medicine);
  Future<List<MedicineModel>?> getMedicine(int id);
  Future<int> updateMedicine(MedicineModel medicine);
  Future<int> deleteMedicine(int id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final DatabaseHelper databaseHelper;

  MedicineLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> insertMedicine(MedicineModel medicine) async {
    try {
      final db = await databaseHelper.database;
      final id = await db.insert(
        DatabaseConstants.medicineTable,
        medicine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      throw LocalDatabaseException('Failed to insert medicine: $e');
    }
  }

  @override
  Future<List<MedicineModel>?> getMedicine(int id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> allMedicine = await db.query(
        DatabaseConstants.medicineTable,
        where: '${DatabaseConstants.medicineId} = ?',
        whereArgs: [id],
      );
      if (allMedicine.isEmpty) {
        return null;
      }
      return allMedicine.map((e) => MedicineModel.fromMap(e)).toList();
    } catch (e) {
      throw LocalDatabaseException('Failed to get medicine: $e');
    }
  }

  @override
  Future<int> updateMedicine(MedicineModel medicine) {
    // TODO: implement updateMedicine
    throw UnimplementedError();
  }

  @override
  Future<int> deleteMedicine(int id) {
    // TODO: implement deleteMedicine
    throw UnimplementedError();
  }
}
