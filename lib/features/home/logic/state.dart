import 'package:castly/core/models/stream_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure, createStreamSuccess }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<StreamModel> streams;
  final String errorMessage;
  final StreamModel? liveStreamModel;

  const HomeState({
    this.status = HomeStatus.initial,
    this.streams = const [],
    this.errorMessage = '',
    this.liveStreamModel,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<StreamModel>? streams,
    String? errorMessage,
    StreamModel? liveStreamModel,
  }) {
    return HomeState(
      status: status ?? this.status,
      streams: streams ?? this.streams,
      errorMessage: errorMessage ?? this.errorMessage,
      liveStreamModel: liveStreamModel ?? this.liveStreamModel,
    );
  }

  @override
  List<Object?> get props => [status, streams, errorMessage, liveStreamModel];
}
