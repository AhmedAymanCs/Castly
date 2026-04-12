import 'package:equatable/equatable.dart';

enum LiveStreamStatus { initial, loading, live, failure }

class LiveStreamState extends Equatable {
  final LiveStreamStatus status;
  final String errorMessage;
  final bool micMuted;
  final bool isLive;

  const LiveStreamState({
    this.status = LiveStreamStatus.initial,
    this.errorMessage = '',
    this.micMuted = false,
    this.isLive = false,
  });

  LiveStreamState copyWith({
    LiveStreamStatus? status,
    String? errorMessage,
    bool? micMuted,
    bool? isLive,
  }) {
    return LiveStreamState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      micMuted: micMuted ?? this.micMuted,
      isLive: isLive ?? this.isLive,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, micMuted, isLive];
}
