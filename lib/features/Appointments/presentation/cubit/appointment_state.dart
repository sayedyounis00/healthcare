part of 'appointment_cubit.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;
  final String? successMessage;
  final String? deleteMessage;
  final int pendingSyncCount;
  final bool isSyncing;
  final String? syncError;

  const AppointmentLoaded({
    required this.appointments,
    this.successMessage,
    this.deleteMessage,
    this.pendingSyncCount = 0,
    this.isSyncing = false,
    this.syncError,
  });

  @override
  List<Object?> get props => [
    appointments,
    successMessage,
    deleteMessage,
    pendingSyncCount,
    isSyncing,
    syncError,
  ];

  bool get hasSuccessMessage => successMessage != null;

  bool get hasDeleteMessage => deleteMessage != null;

  bool get hasNotification => hasSuccessMessage || hasDeleteMessage;

  bool get hasPendingSyncs => pendingSyncCount > 0;

  String get syncStatusMessage {
    if (isSyncing) return 'Syncing...';
    if (pendingSyncCount > 0) {
      return '$pendingSyncCount pending sync${pendingSyncCount > 1 ? 's' : ''}';
    }
    return 'All synced';
  }
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
