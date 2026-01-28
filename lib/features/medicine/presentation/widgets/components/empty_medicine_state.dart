import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class EmptyMedicineState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyMedicineState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            const SizedBox(height: 32),
            const Text(
              'No Medications Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start tracking your medications by adding\nyour first prescription',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.gray600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.skyBlue.withAlpha(128),
            AppColors.lightBlue.withAlpha(77),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.healingGreen.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: AppColors.carePurple.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.medicalBlue.withAlpha(38),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.medication_liquid_rounded,
              size: 50,
              color: AppColors.medicalBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: onAddPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.medicalBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppColors.medicalBlue.withAlpha(77),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_rounded, size: 22),
          SizedBox(width: 8),
          Text(
            'Add First Medicine',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
