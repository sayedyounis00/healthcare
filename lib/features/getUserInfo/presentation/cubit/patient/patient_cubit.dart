import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/getUserInfo/domain/entities/patient.dart';
import 'package:healthcare/features/getUserInfo/domain/repositories/patient_repository.dart';
part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final PatientRepository repository;

  PatientCubit(this.repository) : super(PatientInitial());

  Future<void> createPatient(Patient patient) async {
    emit(PatientLoading());
    final result = await repository.addPatient(patient);
    result.fold(
      (failure) => emit(PatientFailure(failure.message)),
      (patientId) => emit(PatientSuccess(patientId)),
    );
  }
}
