import 'package:get_it/get_it.dart';
import 'package:healthcare/core/local_database/local_databse_helper.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_local_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/datasource/patient_remote_data_source.dart';
import 'package:healthcare/features/getUserInfo/data/repositories/patient_repository_impl.dart';
import 'package:healthcare/features/getUserInfo/domain/repositories/patient_repository.dart';
import 'package:healthcare/features/getUserInfo/presentation/cubit/patient/patient_cubit.dart';

final sl = GetIt.instance;

Future<void> setUp() async {
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Data Sources
  sl.registerLazySingleton<PatientLocalDataSource>(
    () => PatientLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Server_Repositories
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(),
  );
  // Repositories
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory<PatientCubit>(
    () => PatientCubit(
      sl<PatientRepository>(),
    ),
  );
}
