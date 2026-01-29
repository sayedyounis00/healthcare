// lib/features/patient/data/models/patient_model.dart

import 'dart:convert';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';

import '../../domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel({
    super.id,
    required super.name,
    required super.gender,
    required super.birthDate,
    required super.phone,
    required super.email,
    required super.address,
    required super.bloodType,
    required super.emergencyContactName,
    required super.emergencyContactPhone,
    required super.emergencyContactAlternativePhone,
    required super.emergencyContactRelationship,
    required super.emergencyContactAddress,
    required super.chronicConditions,
    required super.allergies,
    required super.currentMedications,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnName: name,
      DatabaseConstants.columnGender: gender,
      DatabaseConstants.columnBirthDate: birthDate.toIso8601String(),
      DatabaseConstants.columnPhone: phone,
      DatabaseConstants.columnEmail: email,
      DatabaseConstants.columnAddress: address,
      DatabaseConstants.columnBloodType: bloodType,
      DatabaseConstants.columnEmergencyContactName: emergencyContactName,
      DatabaseConstants.columnEmergencyContactPhone: emergencyContactPhone,
      DatabaseConstants.columnEmergencyContactAlternativePhone:
          emergencyContactAlternativePhone,
      DatabaseConstants.columnEmergencyContactRelationship:
          emergencyContactRelationship,
      DatabaseConstants.columnEmergencyContactAddress: emergencyContactAddress,
      DatabaseConstants.columnChronicConditions:
          jsonEncode(chronicConditions), // Store lists as JSON strings
      DatabaseConstants.columnAllergies: jsonEncode(allergies),
      DatabaseConstants.columnCurrentMedications: jsonEncode(currentMedications),
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map[DatabaseConstants.columnId] as int?,
      name: map[DatabaseConstants.columnName] as String,
      gender: map[DatabaseConstants.columnGender] as String,
      birthDate: DateTime.parse(map[DatabaseConstants.columnBirthDate] as String),
      phone: map[DatabaseConstants.columnPhone] as String,
      email: map[DatabaseConstants.columnEmail] as String,
      address: map[DatabaseConstants.columnAddress] as String,
      bloodType: map[DatabaseConstants.columnBloodType] as String,
      emergencyContactName:
          map[DatabaseConstants.columnEmergencyContactName] as String,
      emergencyContactPhone:
          map[DatabaseConstants.columnEmergencyContactPhone] as String,
      emergencyContactAlternativePhone:
          map[DatabaseConstants.columnEmergencyContactAlternativePhone] as String,
      emergencyContactRelationship:
          map[DatabaseConstants.columnEmergencyContactRelationship] as String,
      emergencyContactAddress:
          map[DatabaseConstants.columnEmergencyContactAddress] as String,
      chronicConditions: (jsonDecode(map[DatabaseConstants.columnChronicConditions] as String) as List)
          .map((e) => e as String)
          .toList(),
      allergies: (jsonDecode(map[DatabaseConstants.columnAllergies] as String) as List)
          .map((e) => e as String)
          .toList(),
      currentMedications:
          (jsonDecode(map[DatabaseConstants.columnCurrentMedications] as String) as List)
              .map((e) => e as String)
              .toList(),
    );
  }

  factory PatientModel.fromEntity(Patient patient) {
    return PatientModel(
      id: patient.id,
      name: patient.name,
      gender: patient.gender,
      birthDate: patient.birthDate,
      phone: patient.phone,
      email: patient.email,
      address: patient.address,
      bloodType: patient.bloodType,
      emergencyContactName: patient.emergencyContactName,
      emergencyContactPhone: patient.emergencyContactPhone,
      emergencyContactAlternativePhone: patient.emergencyContactAlternativePhone,
      emergencyContactRelationship: patient.emergencyContactRelationship,
      emergencyContactAddress: patient.emergencyContactAddress,
      chronicConditions: patient.chronicConditions,
      allergies: patient.allergies,
      currentMedications: patient.currentMedications,
    );
  }

  PatientModel copyWith({
    int? id,
    String? name,
    String? gender,
    DateTime? birthDate,
    String? phone,
    String? email,
    String? address,
    String? bloodType,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactAlternativePhone,
    String? emergencyContactRelationship,
    String? emergencyContactAddress,
    List<String>? chronicConditions,
    List<String>? allergies,
    List<String>? currentMedications,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodType: bloodType ?? this.bloodType,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactAlternativePhone:
          emergencyContactAlternativePhone ?? this.emergencyContactAlternativePhone,
      emergencyContactRelationship:
          emergencyContactRelationship ?? this.emergencyContactRelationship,
      emergencyContactAddress: emergencyContactAddress ?? this.emergencyContactAddress,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
    );
  }
}