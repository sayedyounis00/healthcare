// lib/core/database/database_constants.dart

class DatabaseConstants {
  static const String databaseName = 'patient_app.db';
  static const int databaseVersion = 1;

  // Table name
  static const String patientTable = 'patient_data';

  // Column names
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnGender = 'gender';
  static const String columnBirthDate = 'birth_date';
  static const String columnPhone = 'phone';
  static const String columnEmail = 'email';
  static const String columnAddress = 'address';
  static const String columnBloodType = 'blood_type';
  static const String columnEmergencyContactName = 'emergency_contact_name';
  static const String columnEmergencyContactPhone = 'emergency_contact_phone';
  static const String columnEmergencyContactAlternativePhone = 'emergency_contact_alternative_phone';
  static const String columnEmergencyContactRelationship = 'emergency_contact_relationship';
  static const String columnEmergencyContactAddress = 'emergency_contact_address';
  static const String columnChronicConditions = 'chronic_conditions';
  static const String columnAllergies = 'allergies';
  static const String columnCurrentMedications = 'current_medications';
}