import 'package:get_it/get_it.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/core/sync/datasource/sync_queue_local_datasource.dart';
import 'package:healthcare/core/sync/sync_manager.dart';
import 'package:healthcare/features/Appointments/data/datasource/appointment_local_datasource.dart';
import 'package:healthcare/features/Appointments/data/datasource/appointment_remote_datasource.dart';
import 'package:healthcare/features/Appointments/data/repository/appointment_repo_impl.dart';
import 'package:healthcare/features/Appointments/domain/repository/appointment_repo.dart';
import 'package:healthcare/features/Appointments/presentation/cubit/appointment_cubit.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_local_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_remote_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/repositories/patient_repository_impl.dart';
import 'package:healthcare/features/getUserInfo/domain/repositories/patient_repository.dart';
import 'package:healthcare/features/getUserInfo/presentation/cubit/patient/patient_cubit.dart';
import 'package:healthcare/features/home/data/datasource/home_local_datasource.dart';
import 'package:healthcare/features/home/data/repository/home_repository_impl.dart';
import 'package:healthcare/features/home/domain/repository/home_repository.dart';
import 'package:healthcare/features/home/presentation/cubit/home_cubit.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_local_datasource.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_remote_datasource.dart';
import 'package:healthcare/features/medicine/data/repository/medicine_repo_impl.dart';
import 'package:healthcare/features/medicine/domain/repository/medicine_repository.dart';
import 'package:healthcare/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:healthcare/features/userProfile/presentaion/cubit/cubit/user_profile_cubit.dart';

final sl = GetIt.instance;

Future<void> setUp() async {
  // Database
  sl.registerLazySingleton<LocalDatabaseHelper>(
    () => LocalDatabaseHelper.instance,
  );

  // Data Sources
  sl.registerLazySingleton<PatientLocalDataSource>(
    () => PatientLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<MedicineLocalDataSource>(
    () => MedicineLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<AppointmentLocalDatasource>(
    () => AppointmentLocalDatasourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Sync Queue Data Source
  sl.registerLazySingleton<SyncQueueLocalDataSource>(
    () => SyncQueueLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Server Data Sources
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MedicineRemoteDataSource>(
    () => MedicineRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(),
  );

  // Sync Manager
  sl.registerLazySingleton<SyncManager>(
    () =>
        SyncManager(syncQueueDataSource: sl(), medicineRemoteDataSource: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MedicineRepository>(
    () => MedicineRepoImpl(
      medicineLocalDataSource: sl(),
      medicineRemoteDataSource: sl(),
      syncManager: sl(),
    ),
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepoImpl(
      appointmentLocalDatasource: sl(),
      appointmentRemoteDataSource: sl(),
      syncManager: sl(),
    ),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
  );

  // Cubits
  sl.registerFactory<PatientCubit>(() => PatientCubit(sl<PatientRepository>()));

  sl.registerFactory<UserProfileCubit>(
    () => UserProfileCubit(sl<PatientRepository>()),
  );
  sl.registerFactory<MedicineCubit>(
    () => MedicineCubit(sl<MedicineRepository>()),
  );
  sl.registerFactory<AppointmentCubit>(
    () => AppointmentCubit(sl<AppointmentRepository>()),
  );
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
}
