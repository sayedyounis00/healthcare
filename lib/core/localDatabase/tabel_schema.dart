import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';

class TabelSchema {
  static final List<GeneratedTableSchema> tableSchemas = [
    //==Patient Table Schema==\\
    GeneratedTableSchema(
      tableName: DatabaseConstants.patientTable,
      columns: [
        const ColumnDefinition(
          name: DatabaseConstants.columnId,
          type: 'INTEGER',
          isPrimaryKey: true,
          isAutoIncrement: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnGender,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnBirthDate,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnPhone,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmail,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnAddress,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnBloodType,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactPhone,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactAlternativePhone,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactRelationship,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnEmergencyContactAddress,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnChronicConditions,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnAllergies,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.columnCurrentMedications,
          type: 'TEXT',
          isNullable: true,
        ),
      ],
    ),
    //==Medicine Table Schema==\\
    GeneratedTableSchema(
      tableName: DatabaseConstants.medicineTable,
      columns: [
        const ColumnDefinition(
          name: DatabaseConstants.medicineId,
          type: 'INTEGER',
          isPrimaryKey: true,
          isAutoIncrement: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicinePatientId,
          type: 'INTEGER',
          isNullable: false,
          references:
              '${DatabaseConstants.patientTable}(${DatabaseConstants.columnId}) ON DELETE CASCADE',
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineDrugName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineDescription,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineTimesToTake,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineTags,
          type: 'TEXT',
          isNullable: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineIsActive,
          type: 'INTEGER',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineCreatedAt,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.medicineUpdatedAt,
          type: 'TEXT',
          isNullable: true,
        ),
      ],
    ),
    //==Sync Queue Table Schema==
    GeneratedTableSchema(
      tableName: DatabaseConstants.syncQueueTable,
      columns: [
        const ColumnDefinition(
          name: DatabaseConstants.syncId,
          type: 'INTEGER',
          isPrimaryKey: true,
          isAutoIncrement: true,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncTableName,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncOperation,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncData,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncRecordId,
          type: 'INTEGER',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncCreatedAt,
          type: 'TEXT',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncRetryCount,
          type: 'INTEGER',
          isNullable: false,
        ),
        const ColumnDefinition(
          name: DatabaseConstants.syncLastError,
          type: 'TEXT',
          isNullable: true,
        ),
      ],
    ),
  ];
}
