import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class EmptyAppointments extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyAppointments({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 48,
                color: AppColors.medicalBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Appointments Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Schedule your first appointment with\nyour healthcare provider',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
            if (onAddPressed != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.medicalBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
