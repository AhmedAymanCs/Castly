import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  const HomeState({this.status = HomeStatus.initial});

  @override
  List<Object?> get props => [status];
}
