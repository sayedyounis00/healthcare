// lib/core/database/database_constants.dart

class DatabaseConstants {
  // Database Configuration
  static const String databaseName = 'patient_app.db';
  static const int databaseVersion = 1;

  // ==========================================
  // TABLE NAMES
  // ==========================================
  static const String patientTable = 'patient_data';
  static const String medicineTable = 'medicine_data';

  // ==========================================
  // PATIENT TABLE COLUMNS
  // ==========================================
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
  static const String columnEmergencyContactAlternativePhone =
      'emergency_contact_alternative_phone';
  static const String columnEmergencyContactRelationship =
      'emergency_contact_relationship';
  static const String columnEmergencyContactAddress =
      'emergency_contact_address';
  static const String columnChronicConditions = 'chronic_conditions';
  static const String columnAllergies = 'allergies';
  static const String columnCurrentMedications = 'current_medications';

  // ==========================================
  // MEDICINE TABLE COLUMNS
  // ==========================================
  static const String medicineId = 'id';
  static const String medicinePatientId = 'patient_id';
  static const String medicineDrugName = 'drug_name';
  static const String medicineDescription = 'description';
  static const String medicineTimesToTake = 'times_to_take';
  static const String medicineTags = 'tags';
  static const String medicineCreatedAt = 'created_at';
  static const String medicineUpdatedAt = 'updated_at';
}
