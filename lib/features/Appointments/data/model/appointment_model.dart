import 'package:flutter/material.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/Appointments/domain/entites/appoinment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    super.id,
    required super.patientId,
    required super.doctorName,
    required super.specialty,
    required super.clinicName,
    required super.date,
    required super.time,
    required super.status,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DatabaseConstants.appointmentId: id,
      DatabaseConstants.appointmentPatientId: patientId,
      DatabaseConstants.appointmentDoctorName: doctorName,
      DatabaseConstants.appointmentSpecialty: specialty,
      DatabaseConstants.appointmentClinicName: clinicName,
      DatabaseConstants.appointmentDate: date.toIso8601String(),
      DatabaseConstants.appointmentTime: time,
      DatabaseConstants.appointmentStatus: status.name,
      DatabaseConstants.appointmentType: type,
      DatabaseConstants.appointmentCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.appointmentUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map[DatabaseConstants.appointmentId] as int?,
      patientId: map[DatabaseConstants.appointmentPatientId] as int,
      doctorName: map[DatabaseConstants.appointmentDoctorName] as String,
      specialty: map[DatabaseConstants.appointmentSpecialty] as String,
      clinicName: map[DatabaseConstants.appointmentClinicName] as String,
      date: DateTime.parse(map[DatabaseConstants.appointmentDate] as String),
      time: map[DatabaseConstants.appointmentTime] as String,
      status: AppointmentStatus.values.byName(
        map[DatabaseConstants.appointmentStatus] as String,
      ),
      type: map[DatabaseConstants.appointmentType] as String,
      createdAt: DateTime.parse(
        map[DatabaseConstants.appointmentCreatedAt] as String,
      ),
      updatedAt: DateTime.parse(
        map[DatabaseConstants.appointmentUpdatedAt] as String,
      ),
    );
  }

  /// Create from Supabase JSON response
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int,
      doctorName: json['doctor_name'] as String,
      specialty: json['specialty'] as String,
      clinicName: json['clinic_name'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      status: AppointmentStatus.values.byName(json['status'] as String),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patient_id': patientId,
      'doctor_name': doctorName,
      'specialty': specialty,
      'clinic_name': clinicName,
      'date': date.toIso8601String(),
      'time': time,
      'status': status.name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from entity
  factory AppointmentModel.fromEntity(Appointment entity) {
    return AppointmentModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorName: entity.doctorName,
      specialty: entity.specialty,
      clinicName: entity.clinicName,
      date: entity.date,
      time: entity.time,
      status: entity.status,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Copy with modifications
  AppointmentModel copyWith({
    int? id,
    int? patientId,
    String? doctorName,
    String? specialty,
    String? clinicName,
    DateTime? date,
    String? time,
    AppointmentStatus? status,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      clinicName: clinicName ?? this.clinicName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Color get statusColor {
    switch (status) {
      case AppointmentStatus.confirmed:
        return const Color(0xFF48BB78);
      case AppointmentStatus.pending:
        return const Color(0xFFED8936);
      case AppointmentStatus.completed:
        return const Color(0xFF4A90E2);
      case AppointmentStatus.cancelled:
        return const Color(0xFFE53E3E);
    }
  }

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}
