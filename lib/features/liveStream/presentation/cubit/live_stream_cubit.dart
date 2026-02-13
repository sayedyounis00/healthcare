import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/liveStream/data/camera_stream_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final CameraStreamDataSource _dataSource;
  StreamSubscription<Uint8List>? _frameSub;

  LiveStreamCubit(this._dataSource) : super(LiveStreamInitial());

  void connect() {
    if (state is LiveStreamConnecting || state is LiveStreamConnected) return;

    emit(LiveStreamConnecting());

    _frameSub = _dataSource.frameStream.listen(
      (bytes) {
        emit(LiveStreamConnected(bytes));
      },
      onError: (error) {
        emit(LiveStreamError(error.toString()));
      },
    );

    _dataSource.connect(
      onStatus: (status, error) {
        if (status == RealtimeSubscribeStatus.channelError) {
          emit(LiveStreamError(error?.toString() ?? 'Channel error'));
        } else if (status == RealtimeSubscribeStatus.closed) {
          emit(LiveStreamDisconnected());
        }
      },
    );
  }

  Future<void> disconnect() async {
    await _frameSub?.cancel();
    _frameSub = null;
    await _dataSource.disconnect();
    emit(LiveStreamDisconnected());
  }

  @override
  Future<void> close() async {
    await _frameSub?.cancel();
    await _dataSource.dispose();
    return super.close();
  }
}
