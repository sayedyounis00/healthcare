// lib/core/database/database_constants.dart

class DatabaseConstants {
  // Database Configuration
  static const String databaseName = 'patient_app.db';
  static const int databaseVersion = 4;

  // ==========================================
  // TABLE NAMES (matching Supabase schema)
  // ==========================================
  static const String patientTable = 'patient_data';
  static const String medicineTable = 'medicine';

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
  // MEDICINE TABLE COLUMNS (matching Supabase schema)
  // ==========================================
  static const String medicineId = 'id';
  static const String medicinePatientId =
      'patient_id'; // ForigenKey(FK) to patient_data.id
  static const String medicineDrugName = 'drug_name';
  static const String medicineDescription = 'description';
  static const String medicineTimesToTake = 'times_to_take';
  static const String medicineTags = 'tags';
  static const String medicineIsActive = 'is_active';
  static const String medicineCreatedAt = 'created_at';
  static const String medicineUpdatedAt = 'updated_at';

  // ==========================================
  // SYNC QUEUE TABLE COLUMNS
  // ==========================================
  static const String syncQueueTable = 'sync_queue';
  static const String syncId = 'id';
  static const String syncTableName = 'table_name';
  static const String syncOperation = 'operation';
  static const String syncData = 'data';
  static const String syncRecordId = 'record_id';
  static const String syncCreatedAt = 'created_at';
  static const String syncRetryCount = 'retry_count';
  static const String syncLastError = 'last_error';

  // Sync operations
  static const String syncOperationInsert = 'insert';
  static const String syncOperationUpdate = 'update';
  static const String syncOperationDelete = 'delete';
}
