import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart'
    hide TimeOfDay;

class NextMedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback? onTap;

  const NextMedicineCard({super.key, required this.medicine, this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    // Find the next time to take this medicine
    int? nextHour;
    int? nextMinute;

    for (final time in medicine.timesToTake) {
      if (_isTimeAfter(time.hour, time.minute, currentHour, currentMinute)) {
        if (nextHour == null ||
            _isTimeBefore(time.hour, time.minute, nextHour, nextMinute!)) {
          nextHour = time.hour;
          nextMinute = time.minute;
        }
      }
    }

    // If no upcoming time today, show the first time
    if (nextHour == null && medicine.timesToTake.isNotEmpty) {
      nextHour = medicine.timesToTake.first.hour;
      nextMinute = medicine.timesToTake.first.minute;
    }

    final timeString = nextHour != null
        ? '${nextHour.toString().padLeft(2, '0')}:${nextMinute.toString().padLeft(2, '0')}'
        : 'Not scheduled';

    // Determine status
    String status = 'Upcoming';
    if (nextHour != null) {
      final nextDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        nextHour,
        nextMinute!,
      );
      final difference = nextDateTime.difference(now);
      if (difference.inMinutes < 0) {
        status = 'Overdue';
      } else if (difference.inMinutes <= 30) {
        status = 'Soon';
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.medicationPrimary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.medicationPrimary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.medication,
                        color: AppColors.medicationPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Next Medicine',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              medicine.drugName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
            if (medicine.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                medicine.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 6),
                Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (medicine.tags.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      children: medicine.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.infoLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.infoDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppColors.info;
      case 'soon':
        return AppColors.warning;
      case 'overdue':
        return AppColors.error;
      case 'taken':
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }

  bool _isTimeAfter(int hour1, int minute1, int hour2, int minute2) {
    return hour1 > hour2 || (hour1 == hour2 && minute1 > minute2);
  }

  bool _isTimeBefore(int hour1, int minute1, int hour2, int minute2) {
    return hour1 < hour2 || (hour1 == hour2 && minute1 < minute2);
  }
}
