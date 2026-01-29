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

  const MedicineLoaded({
    required this.medicines,
    this.successMessage,
    this.deleteMessage,
  });

  @override
  List<Object?> get props => [medicines, successMessage, deleteMessage];

  bool get hasSuccessMessage => successMessage != null;

  bool get hasDeleteMessage => deleteMessage != null;

  bool get hasNotification => hasSuccessMessage || hasDeleteMessage;
}

final class MedicineError extends MedicineState {
  final String message;

  const MedicineError({required this.message});

  @override
  List<Object?> get props => [message];
}
