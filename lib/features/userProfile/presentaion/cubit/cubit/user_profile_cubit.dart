import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthcare/features/getUserInfo/domain/entities/patient.dart';
import 'package:healthcare/features/getUserInfo/domain/repositories/patient_repository.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final PatientRepository _patientRepository;

  UserProfileCubit(this._patientRepository) : super(UserProfileInitial());

  Future<void> loadPatientProfile({int patientId = 1}) async {
    emit(UserProfileLoading());

    final result = await _patientRepository.getPatient(patientId);

    result.fold((failure) => emit(UserProfileError(message: failure.message)), (
      patient,
    ) {
      if (patient == null) {
        emit(UserProfileEmpty());
      } else {
        emit(UserProfileLoaded(patient: patient));
      }
    });
  }

  Future<void> refreshProfile({int patientId = 1}) async {
    await loadPatientProfile(patientId: patientId);
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
