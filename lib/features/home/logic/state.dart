import 'package:castly/features/home/data/model/stream_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure, createStreamSuccess }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<StreamModel> streams;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.streams = const [],
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<StreamModel>? streams,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      streams: streams ?? this.streams,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, streams, errorMessage];
}
