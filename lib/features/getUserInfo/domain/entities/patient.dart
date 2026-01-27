import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int? id;
  final String name;
  final String gender;
  final DateTime birthDate;
  final String phone;
  final String email;
  final String address;
  final String bloodType;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactAlternativePhone;
  final String emergencyContactRelationship;
  final String emergencyContactAddress;
  final List<String> chronicConditions;
  final List<String> allergies;
  final List<String> currentMedications;

  const Patient({
    this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.address,
    required this.bloodType,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactAlternativePhone,
    required this.emergencyContactRelationship,
    required this.emergencyContactAddress,
    required this.chronicConditions,
    required this.allergies,
    required this.currentMedications,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    birthDate,
    phone,
    email,
    address,
    bloodType,
    emergencyContactName,
    emergencyContactPhone,
    emergencyContactAlternativePhone,
    emergencyContactRelationship,
    emergencyContactAddress,
    chronicConditions,
    allergies,
    currentMedications,
  ];
}
