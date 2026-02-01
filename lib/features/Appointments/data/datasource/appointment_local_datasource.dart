import 'package:flutter/material.dart';
import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class AppointmentLocalDatasource {
  Future<void> insertAppointment(AppointmentModel appointment);
  Future<List<AppointmentModel>> getAllAppointment(int patientId);
  Future<int> updateAppointment(AppointmentModel appointment);
  Future<int> deleteAppointment(int id);
}

class AppointmentLocalDatasourceImpl implements AppointmentLocalDatasource {
  final LocalDatabaseHelper databaseHelper;
  bool _tableChecked = false;
  String table = DatabaseConstants.appoinmentTable;

  AppointmentLocalDatasourceImpl({required this.databaseHelper});

  Future<void> _ensureTableExists() async {
    if (_tableChecked) return;
    try {
      final isExist = await databaseHelper.tableExists(
        DatabaseConstants.appoinmentTable,
      );
      if (!isExist) {
        await databaseHelper.createTableByName(
          DatabaseConstants.appoinmentTable,
        );
        debugPrint('✅ Created appoinment table');
      }
      _tableChecked = true;
    } catch (e) {
      debugPrint('❌ Failed to ensure table exists: $e');
      rethrow;
    }
  }

  @override
  Future<void> insertAppointment(AppointmentModel appointment) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      await db.insert(
        table,
        appointment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to insert appoinment: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getAllAppointment(int patientId) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> maps = await db.query(
        table,
        where: '${DatabaseConstants.appointmentPatientId} = ?',
        whereArgs: [patientId],
        orderBy: '${DatabaseConstants.appointmentDate} ASC',
      );
      return maps.map((e) => AppointmentModel.fromMap(e)).toList();
    } catch (e) {
      throw LocalDatabaseException('Failed to get appointments: $e');
    }
  }

  @override
  Future<int> updateAppointment(AppointmentModel appointment) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      return await db.update(
        table,
        appointment.toMap(),
        where: '${DatabaseConstants.appointmentId} = ?',
        whereArgs: [appointment.id],
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to update appointment: $e');
    }
  }

  @override
  Future<int> deleteAppointment(int id) async {
    try {
      await _ensureTableExists();
      final db = await databaseHelper.database;
      return await db.delete(
        table,
        where: '${DatabaseConstants.appointmentId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw LocalDatabaseException('Failed to delete appointment: $e');
    }
  }
}
