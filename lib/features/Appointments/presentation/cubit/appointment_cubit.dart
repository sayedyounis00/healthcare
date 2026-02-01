import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/Appointments/data/repository/appointment_repo_impl.dart';
import 'package:healthcare/features/Appointments/domain/repository/appointment_repo.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository appointmentRepository;
  int _patientId;

  /// default patientID will stay [$1] because there is only one user will created
  AppointmentCubit(this.appointmentRepository, {int patientId = 1})
    : _patientId = patientId,
      super(AppointmentInitial());

  final List<AppointmentModel> _appointments = [];

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  Future<void> loadAppointments() async {
    emit(AppointmentLoading());
    final result = await appointmentRepository.getAppointmentsByPatientId(
      _patientId,
    );
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (
      appointments,
    ) {
      _appointments.clear();
      _appointments.addAll(
        appointments.map(
          (a) => a is AppointmentModel ? a : AppointmentModel.fromEntity(a),
        ),
      );
      final pendingCount = state is AppointmentLoaded
          ? (state as AppointmentLoaded).pendingSyncCount
          : 0;
      emit(
        AppointmentLoaded(
          appointments: List.unmodifiable(_appointments),
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  Future<void> checkSyncStatus() async {
    try {
      final pendingCount = await (appointmentRepository as AppointmentRepoImpl)
          .getPendingSyncCount();
      if (state is AppointmentLoaded) {
        final currentState = state as AppointmentLoaded;
        emit(
          AppointmentLoaded(
            appointments: currentState.appointments,
            pendingSyncCount: pendingCount,
            isSyncing: currentState.isSyncing,
            syncError: currentState.syncError,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );
      }
    } catch (e) {
      emit(AppointmentError(message: 'Failed to check sync status: $e'));
    }
  }

  Future<void> syncNow() async {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;
      try {
        emit(
          AppointmentLoaded(
            appointments: currentState.appointments,
            pendingSyncCount: currentState.pendingSyncCount,
            isSyncing: true,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );

        await (appointmentRepository as AppointmentRepoImpl)
            .syncPendingOperations();

        final newPendingCount =
            await (appointmentRepository as AppointmentRepoImpl)
                .getPendingSyncCount();

        emit(
          AppointmentLoaded(
            appointments: currentState.appointments,
            pendingSyncCount: newPendingCount,
            isSyncing: false,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );
      } catch (e) {
        emit(
          AppointmentLoaded(
            appointments: currentState.appointments,
            pendingSyncCount: currentState.pendingSyncCount,
            isSyncing: false,
            syncError: 'Sync failed: $e',
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );
      }
    }
  }

  Future<void> saveAppointment(AppointmentModel appointment) async {
    emit(AppointmentLoading());

    final appointmentWithPatientId = appointment.copyWith(
      patientId: _patientId,
    );

    final existingIndex = _appointments.indexWhere(
      (a) => a.id == appointmentWithPatientId.id,
    );

    if (existingIndex != -1) {
      final result = await appointmentRepository.updateAppointment(
        appointmentWithPatientId,
      );
      result.fold((failure) => emit(AppointmentError(message: failure.message)), (
        _,
      ) {
        _appointments[existingIndex] = appointmentWithPatientId;
        final pendingCount = state is AppointmentLoaded
            ? (state as AppointmentLoaded).pendingSyncCount
            : 0;
        emit(
          AppointmentLoaded(
            appointments: List.unmodifiable(_appointments),
            successMessage:
                'Appointment with ${appointmentWithPatientId.doctorName} updated successfully!',
            pendingSyncCount: pendingCount,
          ),
        );
      });
    } else {
      final result = await appointmentRepository.addAppointment(
        appointmentWithPatientId,
      );
      result.fold((failure) => emit(AppointmentError(message: failure.message)), (
        id,
      ) {
        final newAppointment = appointmentWithPatientId.copyWith(id: id);
        _appointments.add(newAppointment);
        final pendingCount = state is AppointmentLoaded
            ? (state as AppointmentLoaded).pendingSyncCount
            : 0;
        emit(
          AppointmentLoaded(
            appointments: List.unmodifiable(_appointments),
            successMessage:
                'Appointment with ${appointmentWithPatientId.doctorName} added successfully!',
            pendingSyncCount: pendingCount,
          ),
        );
      });
    }
  }

  Future<void> createAppointment(AppointmentModel appointment) async {
    await saveAppointment(appointment);
  }

  Future<void> getAllAppointments(int patientId) async {
    _patientId = patientId;
    emit(AppointmentLoading());
    final result = await appointmentRepository.getAppointmentsByPatientId(
      patientId,
    );
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (
      appointments,
    ) {
      _appointments.clear();
      _appointments.addAll(
        appointments.map(
          (a) => a is AppointmentModel ? a : AppointmentModel.fromEntity(a),
        ),
      );
      final pendingCount = state is AppointmentLoaded
          ? (state as AppointmentLoaded).pendingSyncCount
          : 0;
      emit(
        AppointmentLoaded(
          appointments: List.unmodifiable(_appointments),
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    await saveAppointment(appointment);
  }

  Future<void> deleteAppointment(int appointmentId) async {
    emit(AppointmentLoading());

    final appointmentIndex = _appointments.indexWhere(
      (a) => a.id == appointmentId,
    );
    if (appointmentIndex == -1) {
      emit(AppointmentError(message: 'Appointment not found'));
      return;
    }

    final doctorName = _appointments[appointmentIndex].doctorName;

    final result = await appointmentRepository.deleteAppointment(appointmentId);
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (
      _,
    ) {
      _appointments.removeAt(appointmentIndex);
      final pendingCount = state is AppointmentLoaded
          ? (state as AppointmentLoaded).pendingSyncCount
          : 0;
      emit(
        AppointmentLoaded(
          appointments: List.unmodifiable(_appointments),
          deleteMessage: 'Appointment with $doctorName deleted successfully!',
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  Future<void> refreshAppointments() async {
    await loadAppointments();
  }

  int get appointmentCount => _appointments.length;

  List<AppointmentModel> get todayAppointments {
    final now = DateTime.now();
    return _appointments.where((a) => _isSameDay(a.date, now)).toList();
  }

  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments
        .where((a) => a.date.isAfter(now) && !_isSameDay(a.date, now))
        .toList();
  }

  List<AppointmentModel> get pastAppointments {
    final now = DateTime.now();
    return _appointments
        .where((a) => a.date.isBefore(now) && !_isSameDay(a.date, now))
        .toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
