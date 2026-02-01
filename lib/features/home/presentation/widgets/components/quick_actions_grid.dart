import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class QuickActionsGrid extends StatelessWidget {
  final int medicineCount;
  final int appointmentCount;
  final VoidCallback? onMedicineTap;
  final VoidCallback? onAppointmentTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onEmergencyTap;

  const QuickActionsGrid({
    super.key,
    this.medicineCount = 0,
    this.appointmentCount = 0,
    this.onMedicineTap,
    this.onAppointmentTap,
    this.onProfileTap,
    this.onEmergencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.camera_indoor_outlined,
                  title: 'Live Camera',
                  subtitle: "see the live prodcast from robot cam.",
                  color: AppColors.medicationPrimary,
                  onTap: onMedicineTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.control_camera_outlined,
                  title: 'Cotrol Robot',
                  subtitle: "Control the robot by joystick",
                  color: AppColors.scheduled,
                  onTap: onAppointmentTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Update info',
                  color: AppColors.carePurple,
                  onTap: onProfileTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.emergency,
                  title: 'Emergency',
                  subtitle: 'Call Ambulance',
                  color: AppColors.emergency,
                  onTap: onEmergencyTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
