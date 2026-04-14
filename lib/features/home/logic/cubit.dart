import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/features/home/data/repository/repositroy.dart';
import 'package:castly/features/home/logic/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final FirebaseAuth _auth;

  HomeCubit(this._homeRepository, this._auth) : super(const HomeState());

  Future<void> createStream(String title) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final streamModel = StreamModel(
      title: title,
      thumbnailUrl: '',
      streamerName: _auth.currentUser!.displayName ?? 'Unknown',
      viewerCount: 0,
      id: AppConstants.channelName,
      uid: _auth.currentUser!.uid,
      isLive: true,
    );
    final result = await _homeRepository.createStream(streamModel);
    result.fold(
      (error) => emit(state.copyWith(status: HomeStatus.failure)),
      (stream) => emit(
        state.copyWith(
          status: HomeStatus.createStreamSuccess,
          liveStreamModel: streamModel,
        ),
      ),
    );
  }

  Future<void> getCurrentStreams() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _homeRepository.getCurrentStreams();
    result.fold(
      (error) => emit(state.copyWith(status: HomeStatus.failure)),
      (streams) =>
          emit(state.copyWith(status: HomeStatus.success, streams: streams)),
    );
  }
}
