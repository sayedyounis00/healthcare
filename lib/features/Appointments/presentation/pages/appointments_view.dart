import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/di/injection.dart';
import 'package:healthcare/features/Appointments/domain/repository/appointment_repo.dart';
import 'package:healthcare/features/Appointments/presentation/cubit/appointment_cubit.dart';
import 'package:healthcare/features/Appointments/presentation/widgets/appointments_view_body.dart';

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentCubit(sl<AppointmentRepository>())..loadAppointments(),
      child: const Scaffold(body: AppointmentsViewBody()),
    );
  }
}
