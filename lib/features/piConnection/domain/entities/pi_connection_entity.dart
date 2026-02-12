/// Entity representing the state of a Raspberry Pi connection
class PiConnectionEntity {
  final String ipAddress;
  final int port;
  final String? deviceName;
  final bool isConnected;
  final DateTime? lastConnected;

  const PiConnectionEntity({
    required this.ipAddress,
    this.port = 5000,
    this.deviceName,
    this.isConnected = false,
    this.lastConnected,
  });
}
