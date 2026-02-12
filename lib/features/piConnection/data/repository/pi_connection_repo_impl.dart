import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/piConnection/data/datasource/pi_connection_datasource.dart';
import 'package:healthcare/features/piConnection/data/models/pi_device_model.dart';
import 'package:healthcare/features/piConnection/domain/repository/pi_connection_repository.dart';

/// Implementation of PiConnectionRepository
class PiConnectionRepoImpl implements PiConnectionRepository {
  final PiConnectionDataSource dataSource;

  PiConnectionRepoImpl({required this.dataSource});

  @override
  bool get isConnected => dataSource.isConnected;

  @override
  PiDeviceModel? get currentDevice => dataSource.currentDevice;

  @override
  Future<Either<Failure, bool>> connect(String ipAddress, int port) async {
    try {
      final result = await dataSource.connect(ipAddress, port);
      if (result) {
        return Right(result);
      } else {
        return Left(
          ServerFailure(message: 'Failed to connect to Raspberry Pi'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Connection error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await dataSource.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Disconnect error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> pingDevice(String ipAddress, int port) async {
    try {
      final result = await dataSource.pingDevice(ipAddress, port);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Ping error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendData(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await dataSource.sendData(data);
      if (result != null) {
        return Right(result);
      } else {
        return Left(ServerFailure(message: 'Failed to send data'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Send data error: $e'));
    }
  }
}
