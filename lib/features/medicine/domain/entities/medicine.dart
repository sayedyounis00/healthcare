import 'package:equatable/equatable.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

class Medicine extends Equatable {
  final int? id;
  final int patientId;
  final String drugName;
  final String description;
  final List<TimeOfDay> timesToTake;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medicine({
    this.id,
    required this.patientId,
    required this.drugName,
    this.description = '',
    this.timesToTake = const [],
    this.tags = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    drugName,
    description,
    timesToTake,
    tags,
    isActive,
    createdAt,
    updatedAt,
  ];
}
