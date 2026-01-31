import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

/// Header widget for the Medicine page
/// Shows title, subtitle, and add button with gradient background
class MedicineHeader extends StatelessWidget {
  final VoidCallback onAddPressed;
  final int medicineCount;

  // Cached static decorations
  static final _containerDecoration = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(32),
      bottomRight: Radius.circular(32),
    ),
  );

  static final _addButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withAlpha(77), width: 1.5),
  );

  static final _statsDecoration = BoxDecoration(
    color: Colors.white.withAlpha(26),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withAlpha(51), width: 1),
  );

  const MedicineHeader({
    super.key,
    required this.onAddPressed,
    required this.medicineCount,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        decoration: _containerDecoration,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Medications',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          medicineCount == 0
                              ? 'No medications added yet'
                              : '$medicineCount medication${medicineCount > 1 ? 's' : ''} tracked',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withAlpha(204),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    _buildAddButton(),
                  ],
                ),
                const SizedBox(height: 20),
                _buildQuickStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Material(
      color: Colors.white.withAlpha(51),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onAddPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: _addButtonDecoration,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _statsDecoration,
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.medication_rounded,
            label: 'Total',
            value: medicineCount.toString(),
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.schedule_rounded,
            label: 'Today',
            value: (medicineCount * 2).toString(),
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Taken',
            value: '0',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withAlpha(230), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withAlpha(179),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 50, width: 1, color: Colors.white.withAlpha(51));
  }
}
