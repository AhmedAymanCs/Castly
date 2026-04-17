import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/core/constants/app_constants.dart';
import 'package:castly/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/core/models/user_model.dart';
import 'package:castly/features/streams/watch_stream/data/repository/repo.dart';
import 'package:castly/features/streams/watch_stream/logic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WatchCubit extends Cubit<WatchState> {
  late RtcEngine engine;
  final StreamModel streamModel;
  final WatchStreamRepository _repository;
  StreamSubscription? _streamSubscription;

  WatchCubit(this.streamModel, this._repository) : super(const WatchState());

  void getUserSession() async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userTempSession,
    );
    final userData = jsonDecode(userSession!);
    final user = UserModel.fromJson(userData);
    emit(state.copyWith(userSession: user));
  }

  Future<void> initAgora() async {
    emit(state.copyWith(status: WatchStatus.loading));
    try {
      engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(appId: dotenv.env['AGORA_APP_ID']!),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onUserJoined: (connection, remoteUid, elapsed) {
            if (isClosed) return;
            emit(
              state.copyWith(
                status: WatchStatus.watching,
                remoteUid: remoteUid,
              ),
            );
          },
          onUserOffline: (connection, remoteUid, reason) {
            if (isClosed) return;
            emit(state.copyWith(remoteUid: 0, streamEnded: true));
          },
        ),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      await engine.enableVideo();

      await engine.joinChannel(
        token: dotenv.env['AGORA_TEMP_TOKEN']!,
        channelId: streamModel.id,
        uid: 1,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      await _repository.updateViewerCount(streamModel.id, true);

      _listenToStream();
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: WatchStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _listenToStream() {
    _streamSubscription = _repository.watchStream(streamModel.id).listen((
      stream,
    ) {
      if (isClosed) return;
      if (stream == null) {
        emit(state.copyWith(streamEnded: true));
        return;
      }
      emit(
        state.copyWith(
          viewerCount: stream.viewerCount,
          streamEnded: !stream.isLive,
        ),
      );
    });
  }

  void toggleChatView() {
    emit(state.copyWith(isShowChatView: !state.isShowChatView));
  }

  Future<void> leaveStream() async {
    emit(state.copyWith(leaveStream: true));
    await _repository.updateViewerCount(streamModel.id, false);
    await _streamSubscription?.cancel();
    await engine.leaveChannel();
    await engine.release();
  }

  @override
  Future<void> close() async {
    if (!state.leaveStream) await leaveStream();
    return super.close();
  }
}
