import 'dart:io';

/// Utility class for checking network connectivity
/// Uses a simple ping approach to check internet connectivity
class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._internal();
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();

  /// Check if internet connection is available
  /// Returns true if connected, false otherwise
  Future<bool> get isConnected async {
    try {
      // Try to ping Google DNS or Cloudflare DNS
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Stream of connectivity changes (simulated with periodic checks)
  /// In a production app, use connectivity_plus package
  Stream<bool> get onConnectivityChanged async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield await isConnected;
    }
  }
}

class TimeoutException implements Exception {
  final String? message;
  TimeoutException([this.message]);
  @override
  String toString() => 'TimeoutException: ${message ?? 'Operation timed out'}';
}
