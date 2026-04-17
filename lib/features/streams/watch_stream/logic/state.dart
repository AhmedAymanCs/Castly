import 'package:castly/core/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum WatchStatus { initial, loading, watching, failure }

class WatchState extends Equatable {
  final WatchStatus status;
  final String errorMessage;
  final int remoteUid;
  final int viewerCount;
  final bool streamEnded;
  final bool leaveStream;
  final bool isShowChatView;
  final UserModel? userSession;
  const WatchState({
    this.status = WatchStatus.initial,
    this.errorMessage = '',
    this.remoteUid = 0,
    this.viewerCount = 0,
    this.streamEnded = false,
    this.leaveStream = false,
    this.isShowChatView = false,
    this.userSession,
  });

  WatchState copyWith({
    WatchStatus? status,
    String? errorMessage,
    int? remoteUid,
    int? viewerCount,
    bool? streamEnded,
    bool? leaveStream,
    bool? isShowChatView,
    UserModel? userSession,
  }) {
    return WatchState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      remoteUid: remoteUid ?? this.remoteUid,
      viewerCount: viewerCount ?? this.viewerCount,
      streamEnded: streamEnded ?? this.streamEnded,
      leaveStream: leaveStream ?? this.leaveStream,
      isShowChatView: isShowChatView ?? this.isShowChatView,
      userSession: userSession ?? this.userSession,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    remoteUid,
    viewerCount,
    streamEnded,
    leaveStream,
    isShowChatView,
    userSession,
  ];
}
