import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:healthcare/features/medicine/presentation/widgets/medicine_view_body.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repository/medicine_repository.dart';

class MedicineView extends StatelessWidget {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicineCubit(sl<MedicineRepository>())..getAllMedicine(1),
      child: const Scaffold(body: MedicineViewBody()),
    );
  }
}
