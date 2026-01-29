import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
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
      emit(MedicineLoaded(medicines: List.unmodifiable(_medicines)));
    });
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
        emit(
          MedicineLoaded(
            medicines: List.unmodifiable(_medicines),
            successMessage:
                '${medicineWithPatientId.drugName} updated successfully!',
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
        emit(
          MedicineLoaded(
            medicines: List.unmodifiable(_medicines),
            successMessage:
                '${medicineWithPatientId.drugName} added successfully!',
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
      emit(MedicineLoaded(medicines: List.unmodifiable(_medicines)));
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
      emit(
        MedicineLoaded(
          medicines: List.unmodifiable(_medicines),
          deleteMessage: '$medicineName deleted successfully!',
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
