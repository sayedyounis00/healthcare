import 'dart:io';

import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/utils/network_info.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MedicineRemoteDataSource {
  Future<MedicineModel> insertMedicine(MedicineModel medicine);
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId);
  Future<MedicineModel> updateMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(int id);
}

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final supabase = Supabase.instance.client;
  final NetworkInfo networkInfo;
  static const String tableName = DatabaseConstants.medicineTable;

  MedicineRemoteDataSourceImpl({NetworkInfo? networkInfo})
    : networkInfo = networkInfo ?? NetworkInfo();

  Future<void> _checkConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException('No internet connection available');
    }
  }

  @override
  Future<MedicineModel> insertMedicine(MedicineModel medicine) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .insert(medicine.toJson())
          .select()
          .single();
      return MedicineModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to insert medicine: ${e.toString()}');
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByPatientId(int patientId) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .select()
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);
      return response.map((json) => MedicineModel.fromJson(json)).toList();
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to get medicines: ${e.toString()}');
    }
  }

  @override
  Future<MedicineModel> updateMedicine(MedicineModel medicine) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .update(medicine.toJson())
          .eq('id', medicine.id!)
          .select()
          .single();
      return MedicineModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update medicine: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteMedicine(int id) async {
    try {
      await _checkConnectivity();
      await supabase.from(tableName).delete().eq('id', id);
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to delete medicine: ${e.toString()}');
    }
  }
}
