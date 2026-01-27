part of 'patient_cubit.dart';

class PatientState {}

final class PatientInitial extends PatientState {}

final class PatientLoading extends PatientState {}

final class PatientSuccess extends PatientState {
  final int patientId;
  PatientSuccess(this.patientId);
}

final class PatientFailure extends PatientState {
  final String message;
  PatientFailure(this.message);
}
