import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:healthcare/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:healthcare/features/medicine/presentation/widgets/components/add_edit_medicine_sheet.dart';
import 'package:healthcare/features/medicine/presentation/widgets/components/empty_medicine_state.dart';
import 'package:healthcare/features/medicine/presentation/widgets/components/medicine_card.dart';
import 'package:healthcare/features/medicine/presentation/widgets/components/medicine_header.dart';

class MedicineViewBody extends StatelessWidget {
  const MedicineViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicineCubit, MedicineState>(
      // Only listen for notification states
      listenWhen: (previous, current) {
        if (current is MedicineLoaded) {
          return current.hasNotification;
        }
        return current is MedicineError;
      },
      listener: _handleStateChanges,
      // Only rebuild for actual content changes
      buildWhen: (previous, current) {
        if (current is MedicineLoaded && previous is MedicineLoaded) {
          // Rebuild only if medicines list changed
          return current.medicines.length != previous.medicines.length ||
              !_areListsEqual(current.medicines, previous.medicines);
        }
        return current is MedicineLoading ||
            current is MedicineLoaded ||
            current is MedicineError ||
            current is MedicineInitial;
      },
      builder: (context, state) {
        return Container(
          color: AppColors.backgroundLight,
          child: Column(
            children: [
              _buildHeader(context, state),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  /// Compare two lists for equality
  bool _areListsEqual(List<MedicineModel> a, List<MedicineModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].updatedAt != b[i].updatedAt) {
        return false;
      }
    }
    return true;
  }

  /// Build header with medicine count from state
  Widget _buildHeader(BuildContext context, MedicineState state) {
    int count = 0;
    if (state is MedicineLoaded) {
      count = state.medicines.length;
    }
    return MedicineHeader(
      onAddPressed: () => _showAddEditSheet(context),
      medicineCount: count,
    );
  }

  void _handleStateChanges(BuildContext context, MedicineState state) {
    if (state is MedicineLoaded) {
      if (state.hasSuccessMessage) {
        _showSnackBar(context, state.successMessage!, isSuccess: true);
      } else if (state.hasDeleteMessage) {
        _showSnackBar(context, state.deleteMessage!, isSuccess: false);
      }
    } else if (state is MedicineError) {
      _showSnackBar(context, state.message, isSuccess: false);
    }
  }

  Widget _buildContent(BuildContext context, MedicineState state) {
    if (state is MedicineLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.medicalBlue),
      );
    }

    if (state is MedicineError) {
      return _buildErrorState(context, state.message);
    }

    if (state is MedicineLoaded) {
      if (state.medicines.isEmpty) {
        return EmptyMedicineState(
          onAddPressed: () => _showAddEditSheet(context),
        );
      }
      return _buildMedicineList(context, state.medicines);
    }

    // Initial state - trigger load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineCubit>().loadMedicines();
    });

    return const Center(
      child: CircularProgressIndicator(color: AppColors.medicalBlue),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MedicineCubit>().loadMedicines();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineList(
    BuildContext context,
    List<MedicineModel> medicines,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<MedicineCubit>().refreshMedicines(),
      color: AppColors.medicalBlue,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        itemCount: medicines.length,
        cacheExtent: 500, // Pre-render items for smoother scrolling
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return MedicineCard(
            key: ValueKey(medicine.id), // Use key for efficient updates
            medicine: medicine,
            onEdit: () => _showAddEditSheet(context, medicine: medicine),
            onDelete: () => _confirmDelete(context, medicine),
          );
        },
      ),
    );
  }

  void _showAddEditSheet(BuildContext context, {MedicineModel? medicine}) {
    final cubit = context.read<MedicineCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(sheetContext).padding.top + 60,
        ),
        child: AddEditMedicineSheet(
          medicine: medicine,
          onSave: (savedMedicine) {
            cubit.saveMedicine(savedMedicine);
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MedicineModel medicine) {
    final cubit = context.read<MedicineCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              'Delete Medicine',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${medicine.drugName}"? This action cannot be undone.',
          style: TextStyle(fontSize: 15, color: AppColors.gray700, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (medicine.id != null) {
                cubit.deleteMedicine(medicine.id!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isSuccess,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.success : AppColors.gray700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
