import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:healthcare/features/piConnection/data/models/pi_device_model.dart';

abstract class PiConnectionDataSource {
  Future<bool> connect(String ipAddress, int port);

  Future<void> disconnect();

  Future<bool> pingDevice(String ipAddress, int port);

  Future<Map<String, dynamic>?> sendData(Map<String, dynamic> data);

  bool get isConnected;

  PiDeviceModel? get currentDevice;
}

class PiConnectionDataSourceImpl implements PiConnectionDataSource {
  Socket? _socket;
  PiDeviceModel? _currentDevice;
  bool _isConnected = false;

  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _pingTimeout = Duration(seconds: 5);

  @override
  bool get isConnected => _isConnected;

  @override
  PiDeviceModel? get currentDevice => _currentDevice;

  @override
  Future<bool> connect(String ipAddress, int port) async {
    try {
      await disconnect();

      debugPrint('🔌 Attempting to connect to $ipAddress:$port...');

      _socket = await Socket.connect(
        ipAddress,
        port,
        timeout: _connectionTimeout,
      );

      _isConnected = true;
      _currentDevice = PiDeviceModel(
        ipAddress: ipAddress,
        port: port,
        isConnected: true,
        lastConnected: DateTime.now(),
      );
      _socket!.listen(
        (data) {
          final response = utf8.decode(data);
          debugPrint('📥 Received from Pi: $response');
        },
        onError: (error) {
          debugPrint('❌ Socket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          debugPrint('🔌 Socket closed by server');
          _handleDisconnection();
        },
      );

      debugPrint('✅ Connected to Raspberry Pi at $ipAddress:$port');
      return true;
    } on SocketException catch (e) {
      debugPrint('❌ Socket connection failed: ${e.message}');
      _handleDisconnection();
      return false;
    } on TimeoutException catch (e) {
      debugPrint('❌ Connection timeout: ${e.message}');
      _handleDisconnection();
      return false;
    } catch (e) {
      debugPrint('❌ Unexpected error during connection: $e');
      _handleDisconnection();
      return false;
    }
  }

  void _handleDisconnection() {
    _isConnected = false;
    _socket?.destroy();
    _socket = null;
    _currentDevice = _currentDevice?.copyWith(isConnected: false);
  }

  @override
  Future<void> disconnect() async {
    try {
      if (_socket != null) {
        await _socket!.close();
        _socket!.destroy();
        _socket = null;
      }
      _isConnected = false;
      _currentDevice = _currentDevice?.copyWith(isConnected: false);
      debugPrint('🔌 Disconnected from Raspberry Pi');
    } catch (e) {
      debugPrint('❌ Error during disconnect: $e');
      _handleDisconnection();
    }
  }

  @override
  Future<bool> pingDevice(String ipAddress, int port) async {
    try {
      debugPrint('🏓 Pinging $ipAddress:$port...');

      final socket = await Socket.connect(
        ipAddress,
        port,
        timeout: _pingTimeout,
      );

      await socket.close();
      socket.destroy();

      debugPrint('✅ Ping successful to $ipAddress:$port');
      return true;
    } catch (e) {
      debugPrint('❌ Ping failed: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> sendData(Map<String, dynamic> data) async {
    if (!_isConnected || _socket == null) {
      debugPrint('❌ Cannot send data: not connected');
      return null;
    }

    try {
      final jsonData = jsonEncode(data);
      _socket!.write(jsonData);
      await _socket!.flush();
      debugPrint('📤 Sent to Pi: $jsonData');

      // Note: In a real implementation, you'd wait for response
      // This is a simplified version
      return {'success': true, 'message': 'Data sent successfully'};
    } catch (e) {
      debugPrint('❌ Failed to send data: $e');
      return null;
    }
  }
}
