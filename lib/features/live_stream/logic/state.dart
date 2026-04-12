import 'package:equatable/equatable.dart';

enum LiveStreamStatus { initial, loading, success, failure }

class LiveStreamState extends Equatable {
  final LiveStreamStatus status;
  final String errorMessage;

  const LiveStreamState({
    this.status = LiveStreamStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, errorMessage];
}
