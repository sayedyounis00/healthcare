import 'package:flutter/foundation.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class MedicineLocalDataSource {
  Future<int> insertMedicine(MedicineModel medicine);
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId);
  Future<int> updateMedicine(MedicineModel medicine);
  Future<int> deleteMedicine(int id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final DatabaseHelper databaseHelper;
  bool _tableChecked = false;

  MedicineLocalDataSourceImpl({required this.databaseHelper});

  Future<void> _ensureTableExists() async {
    if (_tableChecked) return;
    try {
      final isExist = await databaseHelper.tableExists(
        DatabaseConstants.medicineTable,
      );
      if (!isExist) {
        await databaseHelper.createTableByName(DatabaseConstants.medicineTable);
        debugPrint('✅ Created medicine table with FK to patient_data');
      }
      _tableChecked = true;
    } catch (e) {
      debugPrint('❌ Failed to ensure table exists: $e');
      rethrow;
    }
  }

  @override
  Future<int> insertMedicine(MedicineModel medicine) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final map = medicine.toMap();
      map.remove(DatabaseConstants.medicineId);

      final id = await db.insert(
        DatabaseConstants.medicineTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('✅ Inserted medicine: ${medicine.drugName} with id: $id');
      return id;
    } catch (e) {
      throw LocalDatabaseException('Failed to insert medicine: $e');
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> medicines = await db.query(
        DatabaseConstants.medicineTable,
        where: '${DatabaseConstants.medicinePatientId} = ?',
        whereArgs: [patientId],
        orderBy: '${DatabaseConstants.medicineCreatedAt} DESC',
      );
      return medicines.map((e) => MedicineModel.fromMap(e)).toList();
    } catch (e) {
      throw LocalDatabaseException('Failed to get medicines: $e');
    }
  }

  // @override
  // Future<List<MedicineModel>> getAllMedicines() async {
  //   try {
  //     await _ensureTableExists();
  //     final db = await databaseHelper.database;
  //     final List<Map<String, Object?>> medicines = await db.query(
  //       DatabaseConstants.medicineTable,
  //       orderBy: '${DatabaseConstants.medicineCreatedAt} DESC',
  //     );
  //     return medicines.map((e) => MedicineModel.fromMap(e)).toList();
  //   } catch (e) {
  //     throw LocalDatabaseException('Failed to get all medicines: $e');
  //   }
  // }

  @override
  Future<int> updateMedicine(MedicineModel medicine) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final rowsAffected = await db.update(
        DatabaseConstants.medicineTable,
        medicine.toMap(),
        where: '${DatabaseConstants.medicineId} = ?',
        whereArgs: [medicine.id],
      );
      debugPrint('✅ Updated medicine: ${medicine.drugName}');
      return rowsAffected;
    } catch (e) {
      throw LocalDatabaseException('Failed to update medicine: $e');
    }
  }

  @override
  Future<int> deleteMedicine(int id) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final rowsAffected = await db.delete(
        DatabaseConstants.medicineTable,
        where: '${DatabaseConstants.medicineId} = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Deleted medicine with id: $id');
      return rowsAffected;
    } catch (e) {
      throw LocalDatabaseException('Failed to delete medicine: $e');
    }
  }
}
