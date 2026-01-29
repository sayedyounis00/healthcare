import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/error/exceptions.dart';
import '../models/patient_model.dart';

abstract class PatientLocalDataSource {
  Future<int> insertPatient(PatientModel patient);
  Future<PatientModel?> getPatient(int id);
  Future<int> updatePatient(PatientModel patient);
  Future<int> deletePatient(int id);
}

class PatientLocalDataSourceImpl implements PatientLocalDataSource {
  final DatabaseHelper databaseHelper;

  PatientLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> insertPatient(PatientModel patient) async {
    try {
      final db = await databaseHelper.database;
      return await db.insert(
        DatabaseConstants.patientTable,
        patient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to insert patient: $e');
    }
  }

  @override
  Future<PatientModel?> getPatient(int id) async {
    try {
      final db = await databaseHelper.database;
      final maps = await db.query(
        DatabaseConstants.patientTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return PatientModel.fromMap(maps.first);
    } catch (e) {
      throw LocalDatabaseException('Failed to get patient: $e');
    }
  }


  @override
  Future<int> updatePatient(PatientModel patient) async {
    try {
      final db = await databaseHelper.database;
      return await db.update(
        DatabaseConstants.patientTable,
        patient.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [patient.id],
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to update patient: $e');
    }
  }

  @override
  Future<int> deletePatient(int id) async {
    try {
      final db = await databaseHelper.database;
      return await db.delete(
        DatabaseConstants.patientTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to delete patient: $e');
    }
  }


}