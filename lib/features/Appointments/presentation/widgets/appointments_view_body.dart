import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/Appointments/presentation/cubit/appointment_cubit.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/appointment_card.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/appointment_header.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/components/add_edit_appointment_sheet.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/empty_appointments.dart';

class AppointmentsViewBody extends StatelessWidget {
  const AppointmentsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listenWhen: (previous, current) {
        if (current is AppointmentLoaded) {
          return current.hasNotification;
        }
        return current is AppointmentError;
      },
      listener: _handleStateChanges,
      buildWhen: (previous, current) {
        if (current is AppointmentLoaded && previous is AppointmentLoaded) {
          return current.appointments.length != previous.appointments.length ||
              !_areListsEqual(current.appointments, previous.appointments);
        }
        return current is AppointmentLoading ||
            current is AppointmentLoaded ||
            current is AppointmentError ||
            current is AppointmentInitial;
      },
      builder: (context, state) {
        return Container(
          color: AppColors.backgroundLight,
          child: Column(
            children: [
              _buildHeader(context, state),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  bool _areListsEqual(List<AppointmentModel> a, List<AppointmentModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].updatedAt != b[i].updatedAt) {
        return false;
      }
    }
    return true;
  }

  Widget _buildHeader(BuildContext context, AppointmentState state) {
    int todayCount = 0;
    int upcomingCount = 0;
    if (state is AppointmentLoaded) {
      final cubit = context.read<AppointmentCubit>();
      todayCount = cubit.todayAppointments.length;
      upcomingCount = cubit.upcomingAppointments.length;
    }
    return AppointmentsHeader(
      todayCount: todayCount,
      upcomingCount: upcomingCount,
      onAddTap: () => _showAddAppointmentSheet(context),
    );
  }

  void _handleStateChanges(BuildContext context, AppointmentState state) {
    if (state is AppointmentLoaded) {
      if (state.hasSuccessMessage) {
        _showSnackBar(context, state.successMessage!, isSuccess: true);
      } else if (state.hasDeleteMessage) {
        _showSnackBar(context, state.deleteMessage!, isSuccess: false);
      }
    } else if (state is AppointmentError) {
      _showSnackBar(context, state.message, isSuccess: false);
    }
  }

  Widget _buildContent(BuildContext context, AppointmentState state) {
    if (state is AppointmentLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.medicalBlue),
      );
    }

    if (state is AppointmentError) {
      return _buildErrorState(context, state.message);
    }

    if (state is AppointmentLoaded) {
      if (state.appointments.isEmpty) {
        return EmptyAppointments(
          onAddPressed: () => _showAddAppointmentSheet(context),
        );
      }
      final cubit = context.read<AppointmentCubit>();
      return _buildAppointmentsList(
        context,
        cubit.todayAppointments,
        cubit.upcomingAppointments,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentCubit>().loadAppointments();
    });

    return const Center(
      child: CircularProgressIndicator(color: AppColors.medicalBlue),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AppointmentCubit>().loadAppointments();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(
    BuildContext context,
    List<AppointmentModel> todayAppointments,
    List<AppointmentModel> upcomingAppointments,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<AppointmentCubit>().refreshAppointments(),
      color: AppColors.medicalBlue,
      child: CustomScrollView(
        slivers: [
          if (todayAppointments.isNotEmpty) ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Today')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AppointmentCard(
                    key: ValueKey(todayAppointments[index].id),
                    appointment: todayAppointments[index],
                    onMoreTap: () =>
                        _showOptionsSheet(context, todayAppointments[index]),
                  ),
                  childCount: todayAppointments.length,
                ),
              ),
            ),
          ],
          if (upcomingAppointments.isNotEmpty) ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Upcoming')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AppointmentCard(
                    key: ValueKey(upcomingAppointments[index].id),
                    appointment: upcomingAppointments[index],
                    onMoreTap: () =>
                        _showOptionsSheet(context, upcomingAppointments[index]),
                  ),
                  childCount: upcomingAppointments.length,
                ),
              ),
            ),
          ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'See All',
              style: TextStyle(
                color: AppColors.medicalBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentSheet(
    BuildContext context, {
    AppointmentModel? appointment,
  }) {
    final cubit = context.read<AppointmentCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(sheetContext).padding.top + 60,
        ),
        child: AddEditAppointmentSheet(
          appointment: appointment,
          onSave: (savedAppointment) {
            cubit.saveAppointment(savedAppointment);
          },
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, AppointmentModel appointment) {
    final cubit = context.read<AppointmentCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_outlined, color: AppColors.medicalBlue),
              ),
              title: const Text('Edit Appointment'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showAddAppointmentSheet(context, appointment: appointment);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.cancel_outlined, color: AppColors.error),
              ),
              title: const Text('Cancel Appointment'),
              onTap: () {
                Navigator.pop(sheetContext);
                _confirmDelete(context, appointment, cubit);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AppointmentModel appointment,
    AppointmentCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cancel_outlined,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              'Cancel Appointment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel your appointment with "${appointment.doctorName}"? This action cannot be undone.',
          style: TextStyle(fontSize: 15, color: AppColors.gray700, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'No, Keep it',
              style: TextStyle(
                color: AppColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (appointment.id != null) {
                cubit.deleteAppointment(appointment.id!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isSuccess,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.success : AppColors.gray700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
