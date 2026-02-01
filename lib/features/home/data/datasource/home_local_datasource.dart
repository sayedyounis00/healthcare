import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

abstract class HomeLocalDataSource {
  Future<PatientModel?> getPatient(int id);
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId);
  Future<List<AppointmentModel>> getAppointmentsByPatientId(int patientId);
  Future<MedicineModel?> getNextMedicine(int patientId);
  Future<AppointmentModel?> getNextAppointment(int patientId);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final LocalDatabaseHelper databaseHelper;

  HomeLocalDataSourceImpl({required this.databaseHelper});

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
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId) async {
    try {
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

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatientId(
    int patientId,
  ) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, Object?>> maps = await db.query(
        DatabaseConstants.appoinmentTable,
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
  Future<MedicineModel?> getNextMedicine(int patientId) async {
    try {
      final medicines = await getMedicinesByPatientId(patientId);

      if (medicines.isEmpty) return null;

      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      MedicineModel? nextMedicine;
      TimeOfDay? nextTime;

      for (final medicine in medicines) {
        if (!medicine.isActive) continue;

        for (final time in medicine.timesToTake) {
          if (_isTimeAfter(time, currentTime)) {
            if (nextTime == null || _isTimeBefore(time, nextTime)) {
              nextTime = time;
              nextMedicine = medicine;
            }
          }
        }
      }

      if (nextMedicine == null && medicines.isNotEmpty) {
        final activeMedicines = medicines.where((m) => m.isActive).toList();
        if (activeMedicines.isNotEmpty) {
          nextMedicine = activeMedicines.first;
        }
      }

      return nextMedicine;
    } catch (e) {
      throw LocalDatabaseException('Failed to get next medicine: $e');
    }
  }

  @override
  Future<AppointmentModel?> getNextAppointment(int patientId) async {
    try {
      final appointments = await getAppointmentsByPatientId(patientId);

      if (appointments.isEmpty) return null;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final upcomingAppointments = appointments.where((appointment) {
        final appointmentDate = DateTime(
          appointment.date.year,
          appointment.date.month,
          appointment.date.day,
        );
        return appointmentDate.isAtSameMomentAs(today) ||
            appointmentDate.isAfter(today);
      }).toList();

      if (upcomingAppointments.isEmpty) return null;

      upcomingAppointments.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });

      return upcomingAppointments.first;
    } catch (e) {
      throw LocalDatabaseException('Failed to get next appointment: $e');
    }
  }

  bool _isTimeAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
  }

  bool _isTimeBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }
}
