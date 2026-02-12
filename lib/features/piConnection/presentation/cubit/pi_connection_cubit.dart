import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/piConnection/data/models/pi_device_model.dart';
import 'package:healthcare/features/piConnection/domain/repository/pi_connection_repository.dart';

part 'pi_connection_state.dart';

/// Cubit for managing Raspberry Pi connection state
class PiConnectionCubit extends Cubit<PiConnectionState> {
  final PiConnectionRepository repository;

  PiConnectionCubit({required this.repository}) : super(PiConnectionInitial());

  Future<void> scanDevice(String ipAddress, int port) async {
    emit(PiScanning(ipAddress: ipAddress, port: port));

    final result = await repository.pingDevice(ipAddress, port);
    result.fold(
      (failure) => emit(
        PiConnectionError(
          message: failure.message,
          ipAddress: ipAddress,
          port: port,
        ),
      ),
      (isReachable) => emit(
        PiScanComplete(
          ipAddress: ipAddress,
          port: port,
          isReachable: isReachable,
        ),
      ),
    );
  }

  Future<void> connect(String ipAddress, int port, {String? deviceName}) async {
    emit(PiConnecting(ipAddress: ipAddress, port: port));

    final result = await repository.connect(ipAddress, port);
    result.fold(
      (failure) => emit(
        PiConnectionError(
          message: failure.message,
          ipAddress: ipAddress,
          port: port,
        ),
      ),
      (success) {
        if (success) {
          emit(
            PiConnected(
              ipAddress: ipAddress,
              port: port,
              deviceName: deviceName,
              connectedAt: DateTime.now(),
            ),
          );
        } else {
          emit(
            PiConnectionError(
              message: 'Failed to connect to device',
              ipAddress: ipAddress,
              port: port,
            ),
          );
        }
      },
    );
  }

  Future<void> disconnect() async {
    final currentDevice = repository.currentDevice;

    await repository.disconnect();

    emit(
      PiDisconnected(
        previousIpAddress: currentDevice?.ipAddress,
        message: 'Disconnected from device',
      ),
    );
  }

  /// Send data to connected device
  Future<void> sendData(Map<String, dynamic> data) async {
    if (!repository.isConnected) {
      emit(const PiConnectionError(message: 'Not connected to any device'));
      return;
    }

    emit(PiSendingData());

    final result = await repository.sendData(data);
    result.fold(
      (failure) => emit(PiConnectionError(message: failure.message)),
      (response) => emit(PiDataSent(response: response)),
    );
  }

  /// Check current connection status
  bool get isConnected => repository.isConnected;

  /// Get current device
  PiDeviceModel? get currentDevice => repository.currentDevice;
}
