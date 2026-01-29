import 'package:get_it/get_it.dart';
import 'package:healthcare/core/localDatabase/local_databse_helper.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_local_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_remote_data_source.dart';
import 'package:healthcare/features/getUserInfo/data/repositories/patient_repository_impl.dart';
import 'package:healthcare/features/getUserInfo/domain/repositories/patient_repository.dart';
import 'package:healthcare/features/getUserInfo/presentation/cubit/patient/patient_cubit.dart';
import 'package:healthcare/features/medicine/data/datasource/medicine_local_datasource.dart';
import 'package:healthcare/features/medicine/data/repository/medicine_repo_impl.dart';
import 'package:healthcare/features/medicine/domain/repository/medicine_repository.dart';
import 'package:healthcare/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:healthcare/features/userProfile/presentaion/cubit/cubit/user_profile_cubit.dart';

final sl = GetIt.instance;

Future<void> setUp() async {
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Data Sources
  sl.registerLazySingleton<PatientLocalDataSource>(
    () => PatientLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<MedicineLocalDataSource>(
    () => MedicineLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Server_Repositories
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(),
  );
  // Repositories
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MedicineRepository>(
    () => MedicineRepoImpl(medicineLocalDataSource: sl()),
  );

  // Cubits
  sl.registerFactory<PatientCubit>(() => PatientCubit(sl<PatientRepository>()));

  sl.registerFactory<UserProfileCubit>(
    () => UserProfileCubit(sl<PatientRepository>()),
  );
  sl.registerFactory<MedicineCubit>(
    () => MedicineCubit(sl<MedicineRepository>()),
  );
}
