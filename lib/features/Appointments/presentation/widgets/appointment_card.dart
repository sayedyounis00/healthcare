import 'package:flutter/material.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/status_badge.dart';
import 'time_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onMoreTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDoctorAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 14,
                          color: const Color(0xFF718096),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appointment.specialty,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMoreTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF718096),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            appointment.clinicName,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TimeChip(time: appointment.time),
              const SizedBox(width: 8),
              StatusBadge(
                status: appointment.statusLabel,
                color: appointment.statusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person_outline,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}