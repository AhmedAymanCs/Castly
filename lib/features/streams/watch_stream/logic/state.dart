import 'package:equatable/equatable.dart';

enum WatchStatus { initial, loading, watching, failure }

class WatchState extends Equatable {
  final WatchStatus status;
  final String errorMessage;
  final int remoteUid;

  const WatchState({
    this.status = WatchStatus.initial,
    this.errorMessage = '',
    this.remoteUid = 0,
  });

  WatchState copyWith({
    WatchStatus? status,
    String? errorMessage,
    int? remoteUid,
  }) {
    return WatchState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      remoteUid: remoteUid ?? this.remoteUid,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, remoteUid];
}
