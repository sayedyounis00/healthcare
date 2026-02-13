import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class CameraStreamDataSource {
  static const _channelName = 'camera-stream';
  static const _eventName = 'frame';

  RealtimeChannel? _channel;
  StreamController<Uint8List>? _frameController;

  Stream<Uint8List> get frameStream {
    _frameController ??= StreamController<Uint8List>.broadcast();
    return _frameController!.stream;
  }

  void connect({
    void Function(RealtimeSubscribeStatus status, Object? error)? onStatus,
  }) {
    if (_channel != null) return;

    if (_frameController == null || _frameController!.isClosed) {
      _frameController = StreamController<Uint8List>.broadcast();
    }

    final client = Supabase.instance.client;

    _channel = client
        .channel(_channelName)
        .onBroadcast(event: _eventName, callback: _handleBroadcast)
        .subscribe((status, [error]) {
          onStatus?.call(status, error);
        });
  }

  Future<void> disconnect() async {
    await _channel?.unsubscribe();
    _channel = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _frameController?.close();
    _frameController = null;
  }

  void _handleBroadcast(Map<String, dynamic> payload) {
    try {

      String? base64Frame;

      base64Frame = payload['image'] as String?;
      base64Frame ??= payload['frame'] as String?;

      if (base64Frame == null || base64Frame.isEmpty) {
        final inner = payload['payload'];
        if (inner is Map<String, dynamic>) {
          base64Frame = inner['image'] as String?;
          base64Frame ??= inner['frame'] as String?;
        }
      }

      if (base64Frame == null || base64Frame.isEmpty) {
        return;
      }

      final bytes = base64Decode(base64Frame);

      if (_frameController != null && !_frameController!.isClosed) {
        _frameController!.add(bytes);
      }
    } catch (e) {
      if (_frameController != null && !_frameController!.isClosed) {
        _frameController!.addError(e);
      }
    }
  }
}
