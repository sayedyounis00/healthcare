import 'package:flutter/material.dart';
import 'package:healthcare/core/helper/app_helper.dart';
import 'package:healthcare/features/getUserInfo/domain/entities/patient.dart';

class ProfileHeader extends StatelessWidget {
  final Patient patient;
  final int age;
  const ProfileHeader({super.key, required this.patient, required this.age});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getInitials(patient.name),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                patient.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Quick Info
              Text(
                '${patient.gender} • $age years old • ${patient.bloodType}',
                style: const TextStyle(fontSize: 14, color: Color(0xE6FFFFFF)),
              ),
              const SizedBox(height: 16),

              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQuickAction(
                    icon: Icons.phone,
                    label: 'Call',
                    onTap: () =>
                        AppHelper.makePhoneCall(patient.phone, context),
                  ),
                  const SizedBox(width: 24),
                  _buildQuickAction(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => AppHelper.sendEmail(patient.email, context),
                  ),
                  const SizedBox(width: 24),
                  _buildQuickAction(
                    icon: Icons.edit,
                    label: 'Edit',
                    onTap: () {
                      // TODO: Implement edit action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x33FFFFFF),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xE6FFFFFF)),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
