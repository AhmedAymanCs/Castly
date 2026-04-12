import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/features/home/data/model/stream_model.dart';
import 'package:castly/features/live_stream/logic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final StreamModel streamModel;
  late RtcEngine engine;

  LiveStreamCubit(this.streamModel) : super(const LiveStreamState());

  Future<void> initAgora() async {
    emit(state.copyWith(status: LiveStreamStatus.loading));
    try {
      await [Permission.camera, Permission.microphone].request();
      engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(appId: dotenv.env['AGORA_APP_ID']!),
      );

      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine.enableVideo();
      await engine.startPreview();

      await engine.joinChannel(
        token: dotenv.env['AGORA_TEMP_TOKEN']!,
        channelId: streamModel.id,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      emit(state.copyWith(status: LiveStreamStatus.live, isLive: true));
    } catch (e) {
      emit(
        state.copyWith(
          status: LiveStreamStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> toggleMic() async {
    await engine.muteLocalAudioStream(!state.micMuted);
    emit(state.copyWith(micMuted: !state.micMuted));
  }

  Future<void> endStream() async {
    await engine.leaveChannel();
    await engine.release();
    emit(state.copyWith(isLive: false));
  }

  @override
  Future<void> close() {
    engine.leaveChannel();
    engine.release();
    return super.close();
  }
}
