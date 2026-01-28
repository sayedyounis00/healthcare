import 'package:healthcare/core/local_database/local_datebase_constants.dart';
import 'package:healthcare/features/medicine/domain/entities/medicine.dart';

class MedicineModel extends Medicine {
  const MedicineModel({
    super.tags,
    super.description,
    super.timesToTake,
    required super.id,
    required super.patientId,
    required super.drugName,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.medicineId: id,
      DatabaseConstants.medicinePatientId: patientId,
      DatabaseConstants.medicineDrugName: drugName,
      DatabaseConstants.medicineDescription: description,
      DatabaseConstants.medicineTimesToTake: timesToTake,
      DatabaseConstants.medicineTags: tags,
      DatabaseConstants.medicineCreatedAt: createdAt,
      DatabaseConstants.medicineUpdatedAt: updatedAt,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map[DatabaseConstants.medicineId] as String,
      patientId: map[DatabaseConstants.medicinePatientId] as String,
      drugName: map[DatabaseConstants.medicineDrugName] as String,
      description: map[DatabaseConstants.medicineDescription] as String,
      timesToTake:
          map[DatabaseConstants.medicineTimesToTake] as List<TimeOfDay>,
      tags: map[DatabaseConstants.medicineTags] as List<String>,
      createdAt: map[DatabaseConstants.medicineCreatedAt] as DateTime,
      updatedAt: map[DatabaseConstants.medicineUpdatedAt] as DateTime,
    );
  }

  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel(
      id: medicine.id,
      patientId: medicine.patientId,
      drugName: medicine.drugName,
      description: medicine.description,
      timesToTake: medicine.timesToTake,
      tags: medicine.tags,
      createdAt: medicine.createdAt,
      updatedAt: medicine.updatedAt,
    );
  }

  MedicineModel copyWith({
    String? id,
    String? patientId,
    String? drugName,
    String? description,
    List<TimeOfDay>? timesToTake,
    List<String>? tags,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  int get timesPerDay => timesToTake.length;

  bool hasTag(String tag) => tags.contains(tag.toLowerCase());
}

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
