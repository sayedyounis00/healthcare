part of 'medicine_cubit.dart';

sealed class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object?> get props => [];
}

final class MedicineInitial extends MedicineState {}

final class MedicineLoading extends MedicineState {}

final class MedicineLoaded extends MedicineState {
  final List<MedicineModel> medicines;
  final String? successMessage;
  final String? deleteMessage;
  final int pendingSyncCount;
  final bool isSyncing;
  final String? syncError;

  const MedicineLoaded({
    required this.medicines,
    this.successMessage,
    this.deleteMessage,
    this.pendingSyncCount = 0,
    this.isSyncing = false,
    this.syncError,
  });

  @override
  List<Object?> get props => [
    medicines,
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

final class MedicineError extends MedicineState {
  final String message;

  const MedicineError({required this.message});

  @override
  List<Object?> get props => [message];
}
