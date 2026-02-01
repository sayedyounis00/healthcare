import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/core/di/injection.dart';
import 'package:healthcare/core/helper/app_helper.dart';
import 'package:healthcare/features/home/presentation/cubit/home_cubit.dart';
import 'package:healthcare/features/home/presentation/cubit/home_state.dart';
import 'package:healthcare/features/home/presentation/widgets/components/user_info_header.dart';
import 'package:healthcare/features/home/presentation/widgets/components/next_medicine_card.dart';
import 'package:healthcare/features/home/presentation/widgets/components/next_appointment_card.dart';
import 'package:healthcare/features/home/presentation/widgets/components/quick_actions_grid.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const HomeViewBody(),
    );
  }
}

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.medicalBlue),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HomeCubit>().refreshData();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medicalBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            final cubit = context.read<HomeCubit>();
            final patient = state.patient;
            final nextMedicine = state.nextMedicine;
            final nextAppointment = state.nextAppointment;

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.refreshData();
              },
              color: AppColors.medicalBlue,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: UserInfoHeader(
                      name: patient?.name ?? 'Guest',
                      bloodType: patient?.bloodType ?? 'Unknown',
                      age: patient != null
                          ? cubit.calculateAge(patient.birthDate) ?? 0
                          : 0,
                      greeting: state.greeting,
                    ),
                  ),

                  if (nextMedicine != null)
                    SliverToBoxAdapter(
                      child: NextMedicineCard(
                        medicine: nextMedicine,
                        onTap: () {
                        },
                      ),
                    ),

                  // No Medicine State
                  if (nextMedicine == null && state.medicineCount == 0)
                    SliverToBoxAdapter(
                      child: _buildEmptyState(
                        icon: Icons.medication_outlined,
                        title: 'No Medicines',
                        subtitle: 'Add your medications to track them',
                        onTap: () {
                          // Navigate to add medicine
                        },
                      ),
                    ),

                  // Next Appointment Card
                  if (nextAppointment != null)
                    SliverToBoxAdapter(
                      child: NextAppointmentCard(
                        appointment: nextAppointment,
                        onTap: () {
                          // Navigate to appointment details
                        },
                      ),
                    ),

                  // No Appointment State
                  if (nextAppointment == null && state.appointmentCount == 0)
                    SliverToBoxAdapter(
                      child: _buildEmptyState(
                        icon: Icons.calendar_today_outlined,
                        title: 'No Appointments',
                        subtitle: 'Schedule your doctor visits',
                        onTap: () {
                          // Navigate to add appointment
                        },
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: QuickActionsGrid(
                      medicineCount: state.medicineCount,
                      appointmentCount: state.appointmentCount,
                      onMedicineTap: () {
                        // Navigate to medicines
                      },
                      onAppointmentTap: () {
                        // Navigate to appointments
                      },
                      onProfileTap: () {
                        // Navigate to profile
                      },
                      onEmergencyTap: () {
                           AppHelper.makePhoneCall("123", context);
                      },
                    ),
                  ),
                  // Bottom Spacing
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.gray500, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: AppColors.medicalBlue,
              size: 24,
            ),
          ],
        ),
      ),
    );
  } 
}
