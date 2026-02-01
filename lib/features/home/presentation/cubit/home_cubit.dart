import 'package:flutter/material.dart' show debugPrint, TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:healthcare/features/home/domain/repository/home_repository.dart';
import 'package:healthcare/features/home/presentation/cubit/home_state.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart'
    hide TimeOfDay;
import 'package:intl/intl.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  int _patientId;

  HomeCubit(this.homeRepository, {int patientId = 1})
    : _patientId = patientId,
      super(HomeInitial());

  /// Load all home data
  Future<void> loadHomeData() async {
    emit(HomeLoading());

    try {
      // Get patient info
      final patientResult = await homeRepository.getPatient(_patientId);
      PatientModel? patient;
      patientResult.fold(
        (failure) => debugPrint('Failed to get patient: ${failure.message}'),
        (p) => patient = p,
      );

      // Get medicines
      final medicinesResult = await homeRepository.getMedicinesByPatientId(
        _patientId,
      );
      List<MedicineModel> medicines = [];
      medicinesResult.fold(
        (failure) => debugPrint('Failed to get medicines: ${failure.message}'),
        (m) => medicines = m,
      );

      // Get appointments
      final appointmentsResult = await homeRepository
          .getAppointmentsByPatientId(_patientId);
      List<AppointmentModel> appointments = [];
      appointmentsResult.fold(
        (failure) =>
            debugPrint('Failed to get appointments: ${failure.message}'),
        (a) => appointments = a,
      );

      // Get next medicine
      final nextMedicineResult = await homeRepository.getNextMedicine(
        _patientId,
      );
      MedicineModel? nextMedicine;
      nextMedicineResult.fold(
        (failure) =>
            debugPrint('Failed to get next medicine: ${failure.message}'),
        (m) => nextMedicine = m,
      );

      // Get next appointment
      final nextAppointmentResult = await homeRepository.getNextAppointment(
        _patientId,
      );
      AppointmentModel? nextAppointment;
      nextAppointmentResult.fold(
        (failure) =>
            debugPrint('Failed to get next appointment: ${failure.message}'),
        (a) => nextAppointment = a,
      );

      emit(
        HomeLoaded(
          patient: patient,
          medicines: medicines,
          appointments: appointments,
          nextMedicine: nextMedicine,
          nextAppointment: nextAppointment,
          medicineCount: medicines.length,
          appointmentCount: appointments.length,
          greeting: _getGreeting(),
        ),
      );
    } catch (e) {
      emit(HomeError(message: 'Failed to load home data: $e'));
    }
  }

  /// Refresh home data
  Future<void> refreshData() async {
    await loadHomeData();
  }

  /// Set patient ID
  void setPatientId(int patientId) {
    _patientId = patientId;
  }

  /// Get greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Get patient's age from birth date
  int? calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Format time for display
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Format date for display
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (dateToCheck.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
