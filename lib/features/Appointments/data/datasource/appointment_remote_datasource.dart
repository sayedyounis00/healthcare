import 'dart:io';

import 'package:healthcare/core/error/exceptions.dart';
import 'package:healthcare/core/localDatabase/local_datebase_constants.dart';
import 'package:healthcare/core/utils/network_info.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> insertAppointment(AppointmentModel appointment);
  Future<List<AppointmentModel>> getAppointmentsByPatientId(int patientId);
  Future<AppointmentModel> updateAppointment(AppointmentModel appointment);
  Future<void> deleteAppointment(int id);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final supabase = Supabase.instance.client;
  final NetworkInfo networkInfo;
  static const String tableName = DatabaseConstants.appoinmentTable;

  AppointmentRemoteDataSourceImpl({NetworkInfo? networkInfo})
    : networkInfo = networkInfo ?? NetworkInfo();

  Future<void> _checkConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException('No internet connection available');
    }
  }

  @override
  Future<AppointmentModel> insertAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .insert(appointment.toJson())
          .select()
          .single();
      return AppointmentModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to insert appointment: ${e.toString()}');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatientId(
    int patientId,
  ) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .select()
          .eq('patient_id', patientId)
          .order('date', ascending: true);
      return response.map((json) => AppointmentModel.fromJson(json)).toList();
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to get appointments: ${e.toString()}');
    }
  }

  @override
  Future<AppointmentModel> updateAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      await _checkConnectivity();
      final response = await supabase
          .from(tableName)
          .update(appointment.toJson())
          .eq('id', appointment.id!)
          .select()
          .single();
      return AppointmentModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Connection timeout: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update appointment: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAppointment(int id) async {
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
      throw ServerException('Failed to delete appointment: ${e.toString()}');
    }
  }
}
