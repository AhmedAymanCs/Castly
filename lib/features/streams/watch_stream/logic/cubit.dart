import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/features/streams/watch_stream/logic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

class WatchCubit extends Cubit<WatchState> {
  late RtcEngine engine;
  final StreamModel streamModel;

  WatchCubit(this.streamModel) : super(const WatchState());

  Future<void> initAgora() async {
    if (isClosed) return;
    emit(state.copyWith(status: WatchStatus.loading));
    try {
      await Permission.microphone.request();

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
            emit(state.copyWith(remoteUid: 0));
          },
        ),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      await engine.enableVideo();

      await engine.joinChannel(
        token: dotenv.env['AGORA_TEMP_TOKEN']!,
        channelId: streamModel.id,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: WatchStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> leaveStream() async {
    await engine.leaveChannel();
    await engine.release();
  }

  @override
  Future<void> close() {
    engine.leaveChannel();
    engine.release();
    return super.close();
  }
}
