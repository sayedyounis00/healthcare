import 'dart:convert';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/features/medicine/domain/entities/medicine.dart';

/// Medicine model matching Supabase schema
/// Table: medicine
/// Relation: medicine.patient_id → patient_data.id (Foreign Key)
class MedicineModel extends Medicine {
  const MedicineModel({
    super.id,
    required super.patientId,
    required super.drugName,
    super.description,
    super.timesToTake,
    super.tags,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Convert to Map for SQLite database storage
  /// Matches Supabase schema structure
  Map<String, dynamic> toMap() {
    return {
      // id is auto-generated, only include if updating
      if (id != null) DatabaseConstants.medicineId: id,
      DatabaseConstants.medicinePatientId: patientId,
      DatabaseConstants.medicineDrugName: drugName,
      DatabaseConstants.medicineDescription: description,
      // Serialize List<TimeOfDay> as JSON string (matches TEXT[] in Supabase)
      DatabaseConstants.medicineTimesToTake: jsonEncode(
        timesToTake
            .map(
              (t) =>
                  '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
            )
            .toList(),
      ),
      // Serialize List<String> as JSON string (matches TEXT[] in Supabase)
      DatabaseConstants.medicineTags: jsonEncode(tags),
      DatabaseConstants.medicineIsActive: isActive ? 1 : 0,
      DatabaseConstants.medicineCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.medicineUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  /// Create from SQLite database Map
  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    // Parse times from JSON string (format: ["08:00", "14:00", "20:00"])
    final timesJson =
        map[DatabaseConstants.medicineTimesToTake] as String? ?? '[]';
    final timesList = (jsonDecode(timesJson) as List).map((timeStr) {
      final parts = (timeStr as String).split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();

    // Parse tags from JSON string
    final tagsJson = map[DatabaseConstants.medicineTags] as String? ?? '[]';
    final tagsList = (jsonDecode(tagsJson) as List).cast<String>();

    return MedicineModel(
      id: map[DatabaseConstants.medicineId] as int?,
      patientId: map[DatabaseConstants.medicinePatientId] as int,
      drugName: map[DatabaseConstants.medicineDrugName] as String,
      description:
          (map[DatabaseConstants.medicineDescription] as String?) ?? '',
      timesToTake: timesList,
      tags: tagsList,
      isActive: (map[DatabaseConstants.medicineIsActive] as int?) == 1,
      createdAt: DateTime.parse(
        map[DatabaseConstants.medicineCreatedAt] as String,
      ),
      updatedAt: DateTime.parse(
        map[DatabaseConstants.medicineUpdatedAt] as String,
      ),
    );
  }

  /// Create from Supabase JSON response
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    // Parse times from Supabase TEXT[] (comes as List<String>)
    final timesList = (json['times_to_take'] as List? ?? []).map((timeStr) {
      final parts = (timeStr as String).split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();

    // Parse tags from Supabase TEXT[]
    final tagsList = (json['tags'] as List? ?? []).cast<String>();

    return MedicineModel(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int,
      drugName: json['drug_name'] as String,
      description: (json['description'] as String?) ?? '',
      timesToTake: timesList,
      tags: tagsList,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'patient_id': patientId,
      'drug_name': drugName,
      'description': description,
      // Supabase expects TEXT[] as List<String>
      'times_to_take': timesToTake
          .map(
            (t) =>
                '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
          )
          .toList(),
      'tags': tags,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from entity
  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel(
      id: medicine.id,
      patientId: medicine.patientId,
      drugName: medicine.drugName,
      description: medicine.description,
      timesToTake: medicine.timesToTake,
      tags: medicine.tags,
      isActive: medicine.isActive,
      createdAt: medicine.createdAt,
      updatedAt: medicine.updatedAt,
    );
  }

  /// Copy with modifications
  MedicineModel copyWith({
    int? id,
    int? patientId,
    String? drugName,
    String? description,
    List<TimeOfDay>? timesToTake,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      drugName: drugName ?? this.drugName,
      description: description ?? this.description,
      timesToTake: timesToTake ?? this.timesToTake,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Format time for display
  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Get number of times per day
  int get timesPerDay => timesToTake.length;

  /// Check if medicine has a specific tag
  bool hasTag(String tag) => tags.contains(tag.toLowerCase());
}

/// Custom TimeOfDay class (to avoid conflict with Flutter's TimeOfDay)
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;
  int get hourOfPeriod => hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeOfDay && other.hour == hour && other.minute == minute;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;

  @override
  String toString() => 'TimeOfDay(hour: $hour, minute: $minute)';
}

enum DayPeriod { am, pm }

/// Predefined medicine tags
class MedicineTags {
  static const List<String> predefined = [
    'antibiotics',
    'painkillers',
    'vitamins',
    'high-pressure',
    'diabetes',
    'heart',
    'allergy',
    'digestive',
    'sleep',
    'anxiety',
  ];

  static int getColorIndex(String tag) {
    return tag.hashCode.abs() % 10;
  }
}
