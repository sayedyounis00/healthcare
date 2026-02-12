part of 'pi_connection_cubit.dart';

/// Connection status enum
enum PiConnectionStatus {
  initial,
  connecting,
  connected,
  disconnected,
  scanning,
  error,
}

/// States for Pi Connection
abstract class PiConnectionState extends Equatable {
  const PiConnectionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PiConnectionInitial extends PiConnectionState {}

/// Connecting to device
class PiConnecting extends PiConnectionState {
  final String ipAddress;
  final int port;

  const PiConnecting({required this.ipAddress, required this.port});

  @override
  List<Object?> get props => [ipAddress, port];
}

/// Successfully connected
class PiConnected extends PiConnectionState {
  final String ipAddress;
  final int port;
  final String? deviceName;
  final DateTime connectedAt;

  const PiConnected({
    required this.ipAddress,
    required this.port,
    this.deviceName,
    required this.connectedAt,
  });

  @override
  List<Object?> get props => [ipAddress, port, deviceName, connectedAt];
}

/// Scanning/Pinging device
class PiScanning extends PiConnectionState {
  final String ipAddress;
  final int port;

  const PiScanning({required this.ipAddress, required this.port});

  @override
  List<Object?> get props => [ipAddress, port];
}

/// Scan result
class PiScanComplete extends PiConnectionState {
  final String ipAddress;
  final int port;
  final bool isReachable;

  const PiScanComplete({
    required this.ipAddress,
    required this.port,
    required this.isReachable,
  });

  @override
  List<Object?> get props => [ipAddress, port, isReachable];
}

/// Disconnected state
class PiDisconnected extends PiConnectionState {
  final String? previousIpAddress;
  final String? message;

  const PiDisconnected({this.previousIpAddress, this.message});

  @override
  List<Object?> get props => [previousIpAddress, message];
}

/// Error state
class PiConnectionError extends PiConnectionState {
  final String message;
  final String? ipAddress;
  final int? port;

  const PiConnectionError({required this.message, this.ipAddress, this.port});

  @override
  List<Object?> get props => [message, ipAddress, port];
}

/// Loading saved device
class PiLoadingSavedDevice extends PiConnectionState {}

/// Saved device loaded
class PiSavedDeviceLoaded extends PiConnectionState {
  final String ipAddress;
  final int port;
  final String? deviceName;

  const PiSavedDeviceLoaded({
    required this.ipAddress,
    required this.port,
    this.deviceName,
  });

  @override
  List<Object?> get props => [ipAddress, port, deviceName];
}

/// Data sending state
class PiSendingData extends PiConnectionState {}

/// Data sent successfully
class PiDataSent extends PiConnectionState {
  final Map<String, dynamic> response;

  const PiDataSent({required this.response});

  @override
  List<Object?> get props => [response];
}
