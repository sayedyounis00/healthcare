import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/getUserInfo/domain/entities/patient.dart';
import 'package:healthcare/features/userProfile/presentaion/cubit/cubit/user_profile_cubit.dart';
import 'package:healthcare/features/userProfile/presentaion/widgets/pageComponent/chip_list.dart';
import 'package:healthcare/features/userProfile/presentaion/widgets/pageComponent/info_row.dart';
import 'package:healthcare/features/userProfile/presentaion/widgets/pageComponent/profile_header.dart';
import 'package:intl/intl.dart';

class UserProfileContent extends StatelessWidget {
  final Patient patient;
  const UserProfileContent({super.key, required this.patient});
  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(patient.birthDate);
    return RefreshIndicator(
      onRefresh: () => context.read<UserProfileCubit>().refreshProfile(),
      color: const Color(0xFF2196F3),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileHeader(patient: patient, age: age),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard( 
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                    children: [
                      InfoRow(label: 'Full Name', value: patient.name),
                      InfoRow(label: 'Gender', value: patient.gender),
                      InfoRow(
                        label: 'Date of Birth',
                        value: DateFormat(
                          'MMMM dd, yyyy',
                        ).format(patient.birthDate),
                      ),
                      InfoRow(label: 'Age', value: '$age years'),
                      InfoRow(label: 'Blood Type', value: patient.bloodType),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    title: 'Contact Information',
                    icon: Icons.contact_phone_outlined,
                    children: [
                      InfoRow(label: 'Phone', value: patient.phone),
                      InfoRow(label: 'Email', value: patient.email),
                      InfoRow(label: 'Address', value: patient.address),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    title: 'Emergency Contact',
                    icon: Icons.emergency_outlined,
                    iconColor: Colors.red,
                    children: [
                      InfoRow(
                        label: 'Name',
                        value: patient.emergencyContactName,
                      ),
                      InfoRow(
                        label: 'Relationship',
                        value: patient.emergencyContactRelationship,
                      ),
                      InfoRow(
                        label: 'Phone',
                        value: patient.emergencyContactPhone,
                      ),
                      if (patient.emergencyContactAlternativePhone.isNotEmpty)
                        InfoRow(
                          label: 'Alt. Phone',
                          value: patient.emergencyContactAlternativePhone,
                        ),
                      InfoRow(
                        label: 'Address',
                        value: patient.emergencyContactAddress,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Medical Information',
                    icon: Icons.medical_information_outlined,
                    iconColor: const Color(0xFF4CAF50),
                    children: [
                      ChipList(
                        label: 'Chronic Conditions',
                        items: patient.chronicConditions,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      ChipList(
                        label: 'Allergies',
                        items: patient.allergies,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      ChipList(
                        label: 'Current Medications',
                        items: patient.currentMedications,
                        color: const Color(0xFF2196F3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    Color iconColor = const Color(0xFF2196F3),
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}