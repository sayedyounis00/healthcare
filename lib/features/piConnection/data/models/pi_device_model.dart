/// Model representing a Raspberry Pi device connection
class PiDeviceModel {
  final String? id;
  final String ipAddress;
  final int port;
  final String? deviceName;
  final bool isConnected;
  final DateTime? lastConnected;

  const PiDeviceModel({
    this.id,
    required this.ipAddress,
    this.port = 5000,
    this.deviceName,
    this.isConnected = false,
    this.lastConnected,
  });

  PiDeviceModel copyWith({
    String? id,
    String? ipAddress,
    int? port,
    String? deviceName,
    bool? isConnected,
    DateTime? lastConnected,
  }) {
    return PiDeviceModel(
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      deviceName: deviceName ?? this.deviceName,
      isConnected: isConnected ?? this.isConnected,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip_address': ipAddress,
      'port': port,
      'device_name': deviceName,
      'is_connected': isConnected,
      'last_connected': lastConnected?.toIso8601String(),
    };
  }

  factory PiDeviceModel.fromJson(Map<String, dynamic> json) {
    return PiDeviceModel(
      id: json['id'] as String?,
      ipAddress: json['ip_address'] as String,
      port: json['port'] as int? ?? 5000,
      deviceName: json['device_name'] as String?,
      isConnected: json['is_connected'] as bool? ?? false,
      lastConnected: json['last_connected'] != null
          ? DateTime.parse(json['last_connected'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'PiDeviceModel(ipAddress: $ipAddress, port: $port, deviceName: $deviceName, isConnected: $isConnected)';
  }
}
