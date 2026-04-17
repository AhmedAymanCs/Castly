import 'package:castly/core/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum LiveStreamStatus { initial, loading, live, failure }

class LiveStreamState extends Equatable {
  final LiveStreamStatus status;
  final String errorMessage;
  final bool micMuted;
  final bool isLive;
  final bool isShowChatView;
  final UserModel? userSession;

  const LiveStreamState({
    this.status = LiveStreamStatus.initial,
    this.errorMessage = '',
    this.micMuted = false,
    this.isLive = false,
    this.isShowChatView = false,
    this.userSession,
  });

  LiveStreamState copyWith({
    LiveStreamStatus? status,
    String? errorMessage,
    bool? micMuted,
    bool? isLive,
    bool? isShowChatView,
    UserModel? userSession,
  }) {
    return LiveStreamState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      micMuted: micMuted ?? this.micMuted,
      isLive: isLive ?? this.isLive,
      isShowChatView: isShowChatView ?? this.isShowChatView,
      userSession: userSession ?? this.userSession,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    micMuted,
    isLive,
    isShowChatView,
    userSession,
  ];
}
