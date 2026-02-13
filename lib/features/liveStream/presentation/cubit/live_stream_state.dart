part of 'live_stream_cubit.dart';

sealed class LiveStreamState extends Equatable {
  const LiveStreamState();

  @override
  List<Object?> get props => [];
}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamConnecting extends LiveStreamState {}

class LiveStreamConnected extends LiveStreamState {
  final Uint8List imageBytes;

  const LiveStreamConnected(this.imageBytes);

  @override
  List<Object?> get props => [imageBytes];
}

class LiveStreamDisconnected extends LiveStreamState {}

class LiveStreamError extends LiveStreamState {
  final String message;

  const LiveStreamError(this.message);

  @override
  List<Object?> get props => [message];
}
