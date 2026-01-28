import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart'
    as models;
import 'package:healthcare/features/medicine/presentation/widgets/components/medicine_tag_chip.dart';

/// A beautifully designed card for displaying medicine information
class MedicineCard extends StatelessWidget {
  final models.MedicineModel medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  // Cached static decorations for performance
  static final _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.medicalBlue.withAlpha(20),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withAlpha(8),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final _headerDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.medicalBlue.withAlpha(13),
        AppColors.skyBlue.withAlpha(51),
      ],
    ),
  );

  static final _iconDecoration = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: AppColors.medicalBlue.withAlpha(77),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static final _warningDecoration = BoxDecoration(
    color: AppColors.warningLight,
    borderRadius: BorderRadius.circular(10),
  );

  static final _timeSlotDecoration = BoxDecoration(
    color: AppColors.skyBlue,
    borderRadius: BorderRadius.circular(10),
  );

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: _cardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), _buildContent(), _buildFooter()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      decoration: _headerDecoration,
      child: Row(
        children: [
          _buildMedicineIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.drugName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppColors.gray500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${medicine.timesPerDay}x daily',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildMoreButton(),
        ],
      ),
    );
  }

  Widget _buildMedicineIcon() {
    return Container(
      width: 52,
      height: 52,
      decoration: _iconDecoration,
      child: const Icon(
        Icons.medication_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  Widget _buildMoreButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.gray600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 20, color: AppColors.medicalBlue),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: 20, color: AppColors.error),
              SizedBox(width: 12),
              Text('Delete'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (medicine.description.isNotEmpty) ...[
            Text(
              medicine.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray700,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
          ],
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (medicine.timesToTake.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: _warningDecoration,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: AppColors.warningDark,
            ),
            SizedBox(width: 8),
            Text(
              'No schedule set',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.warningDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: medicine.timesToTake.map((time) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: _timeSlotDecoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getTimeIcon(time), size: 16, color: AppColors.deepBlue),
              const SizedBox(width: 6),
              Text(
                _formatTime(time),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepBlue,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    if (medicine.tags.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          MedicineTagsList(tags: medicine.tags),
        ],
      ),
    );
  }

  IconData _getTimeIcon(models.TimeOfDay time) {
    if (time.hour >= 5 && time.hour < 12) {
      return Icons.wb_sunny_outlined;
    } else if (time.hour >= 12 && time.hour < 17) {
      return Icons.wb_twilight_outlined;
    } else if (time.hour >= 17 && time.hour < 21) {
      return Icons.nights_stay_outlined;
    } else {
      return Icons.dark_mode_outlined;
    }
  }

  String _formatTime(models.TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == models.DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
