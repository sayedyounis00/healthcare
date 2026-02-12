import 'package:dartz/dartz.dart';
import 'package:healthcare/core/error/failures.dart';
import 'package:healthcare/features/piConnection/data/models/pi_device_model.dart';

abstract class PiConnectionRepository {
  Future<Either<Failure, bool>> connect(String ipAddress, int port);

  Future<Either<Failure, void>> disconnect();

  Future<Either<Failure, bool>> pingDevice(String ipAddress, int port);

  Future<Either<Failure, Map<String, dynamic>>> sendData(
    Map<String, dynamic> data,
  );

  bool get isConnected;

  PiDeviceModel? get currentDevice;
}
