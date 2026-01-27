import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PatientRemoteDataSource {
  Future<PatientModel> insertPatient(PatientModel patient,String tableName);
  Future<PatientModel> getPatientById(int id,String tableName);
  Future<PatientModel> updatePatient(PatientModel patient,String tableName);
  Future<void> deletePatient(int id,String tableName);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final supabase = Supabase.instance.client;
    @override
    Future<PatientModel> insertPatient(PatientModel patient,String tableName)async {
      try {
        final response = await supabase
            .from(tableName)
            .insert(patient.toMap())
            .select()
            .single();

        return PatientModel.fromMap(response);
      } on PostgrestException catch (e) {
        throw ServerException( e.message);
      } catch (e) {
        throw ServerException('Failed to add patient: ${e.toString()}');
      }
    }

    @override
    Future<PatientModel> getPatientById(int id,String tableName) {
      throw UnimplementedError();
    }

    @override
    Future<PatientModel> updatePatient(PatientModel patient,String tableName) {
      throw UnimplementedError();
    }

    @override
    Future<void> deletePatient(int id,String tableName) {
      throw UnimplementedError();
    }
}
