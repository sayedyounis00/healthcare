import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:healthcare/features/medicine/data/repository/medicine_repo_impl.dart';
import 'package:healthcare/features/medicine/domain/repository/medicine_repository.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository medicineRepository;
  int _patientId;

  /// default patientID will stay [$1] because there is only one user will created
  MedicineCubit(this.medicineRepository, {int patientId = 1})
    : _patientId = patientId,
      super(MedicineInitial());

  final List<MedicineModel> _medicines = [];

  List<MedicineModel> get medicines => List.unmodifiable(_medicines);

  /// Load all medicines for the current patient
  Future<void> loadMedicines() async {
    emit(MedicineLoading());
    final result = await medicineRepository.getMedicineBypatientId(_patientId);
    result.fold((failure) => emit(MedicineError(message: failure.message)), (
      medicines,
    ) {
      _medicines.clear();
      _medicines.addAll(
        medicines.map(
          (m) => m is MedicineModel ? m : MedicineModel.fromEntity(m),
        ),
      );
      final pendingCount = state is MedicineLoaded
          ? (state as MedicineLoaded).pendingSyncCount
          : 0;
      emit(
        MedicineLoaded(
          medicines: List.unmodifiable(_medicines),
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  /// Check sync status and get pending sync count
  Future<void> checkSyncStatus() async {
    try {
      final pendingCount = await (medicineRepository as MedicineRepoImpl)
          .getPendingSyncCount();
      if (state is MedicineLoaded) {
        final currentState = state as MedicineLoaded;
        emit(
          MedicineLoaded(
            medicines: currentState.medicines,
            pendingSyncCount: pendingCount,
            isSyncing: currentState.isSyncing,
            syncError: currentState.syncError,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );
      }
    } catch (e) {
      emit(MedicineError(message: 'Failed to check sync status: $e'));
    }
  }

  /// Trigger manual sync of pending operations
  Future<void> syncNow() async {
    if (state is MedicineLoaded) {
      final currentState = state as MedicineLoaded;
      try {
        emit(
          MedicineLoaded(
            medicines: currentState.medicines,
            pendingSyncCount: currentState.pendingSyncCount,
            isSyncing: true,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );

        await (medicineRepository as MedicineRepoImpl).syncPendingOperations();

        final newPendingCount = await (medicineRepository as MedicineRepoImpl)
            .getPendingSyncCount();

        emit(
          MedicineLoaded(
            medicines: currentState.medicines,
            pendingSyncCount: newPendingCount,
            isSyncing: false,
            successMessage: currentState.successMessage,
            deleteMessage: currentState.deleteMessage,
          ),
        );
      } catch (e) {
        emit(
          MedicineLoaded(
            medicines: currentState.medicines,
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

  /// Save a medicine (create or update)
  Future<void> saveMedicine(MedicineModel medicine) async {
    emit(MedicineLoading());

    final medicineWithPatientId = medicine.copyWith(patientId: _patientId);

    final existingIndex = _medicines.indexWhere(
      (m) => m.id == medicineWithPatientId.id,
    );

    if (existingIndex != -1) {
      final result = await medicineRepository.updateMedicine(
        medicineWithPatientId,
      );
      result.fold((failure) => emit(MedicineError(message: failure.message)), (
        _,
      ) {
        _medicines[existingIndex] = medicineWithPatientId;
        final pendingCount = state is MedicineLoaded
            ? (state as MedicineLoaded).pendingSyncCount
            : 0;
        emit(
          MedicineLoaded(
            medicines: List.unmodifiable(_medicines),
            successMessage:
                '${medicineWithPatientId.drugName} updated successfully!',
            pendingSyncCount: pendingCount,
          ),
        );
      });
    } else {
      // Create new medicine
      final result = await medicineRepository.addMedicine(
        medicineWithPatientId,
      );
      result.fold((failure) => emit(MedicineError(message: failure.message)), (
        id,
      ) {
        final newMedicine = medicineWithPatientId.copyWith(id: id);
        _medicines.add(newMedicine);
        final pendingCount = state is MedicineLoaded
            ? (state as MedicineLoaded).pendingSyncCount
            : 0;
        emit(
          MedicineLoaded(
            medicines: List.unmodifiable(_medicines),
            successMessage:
                '${medicineWithPatientId.drugName} added successfully!',
            pendingSyncCount: pendingCount,
          ),
        );
      });
    }
  }

  /// Create a new medicine
  Future<void> createMedicine(MedicineModel medicine) async {
    await saveMedicine(medicine);
  }

  /// Get all medicines for a specific patient
  Future<void> getAllMedicine(int patientId) async {
    _patientId = patientId; // Update current patient ID
    emit(MedicineLoading());
    final result = await medicineRepository.getMedicineBypatientId(patientId);
    result.fold((failure) => emit(MedicineError(message: failure.message)), (
      medicines,
    ) {
      _medicines.clear();
      _medicines.addAll(
        medicines.map(
          (m) => m is MedicineModel ? m : MedicineModel.fromEntity(m),
        ),
      );
      final pendingCount = state is MedicineLoaded
          ? (state as MedicineLoaded).pendingSyncCount
          : 0;
      emit(
        MedicineLoaded(
          medicines: List.unmodifiable(_medicines),
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  /// Update an existing medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    await saveMedicine(medicine);
  }

  /// Delete a medicine by ID
  Future<void> deleteMedicine(int medicineId) async {
    emit(MedicineLoading());

    // Find the medicine to get its name for the message
    final medicineIndex = _medicines.indexWhere((m) => m.id == medicineId);
    if (medicineIndex == -1) {
      emit(MedicineError(message: 'Medicine not found'));
      return;
    }

    final medicineName = _medicines[medicineIndex].drugName;

    final result = await medicineRepository.deleteMedicine(medicineId);
    result.fold((failure) => emit(MedicineError(message: failure.message)), (
      _,
    ) {
      _medicines.removeAt(medicineIndex);
      final pendingCount = state is MedicineLoaded
          ? (state as MedicineLoaded).pendingSyncCount
          : 0;
      emit(
        MedicineLoaded(
          medicines: List.unmodifiable(_medicines),
          deleteMessage: '$medicineName deleted successfully!',
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  /// Refresh medicines list
  Future<void> refreshMedicines() async {
    await loadMedicines();
  }

  /// Get the count of medicines
  int get medicineCount => _medicines.length;

  /// Calculate total doses for today
  double get totalDosesToday {
    int total = 0;
    for (final medicine in _medicines) {
      total += medicine.timesPerDay;
    }
    return total.toDouble();
  }
}
