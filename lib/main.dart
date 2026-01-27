import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/di/injection.dart' as di;
import 'package:healthcare/core/init/app_initializer.dart';
import 'package:healthcare/features/getUserInfo/presentation/cubit/patient/patient_cubit.dart';
import 'package:healthcare/features/getUserInfo/presentation/pages/get_usr_info.dart';

void main() async {
  await AppInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => di.sl<PatientCubit>(),
        child: const GetUserInfo(),
      ),
    );
  }
}
