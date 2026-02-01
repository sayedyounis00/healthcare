import 'package:equatable/equatable.dart';

enum AppointmentStatus { confirmed, pending, completed, cancelled }

class Appointment extends Equatable {
  final int? id;
  final int patientId;
  final String doctorName;
  final String specialty;
  final String clinicName;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    this.id,
    required this.patientId,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.date,
    required this.time,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    doctorName,
    specialty,
    clinicName,
    date,
    time,
    status,
    type,
    createdAt,
    updatedAt,
  ];
}
