import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/features/streams/live_stream/data/repository/repo.dart';
import 'package:castly/features/streams/live_stream/logic/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final StreamModel streamModel;
  final LiveStreamRepository _liveStreamRepository;
  late RtcEngine engine;

  LiveStreamCubit(this.streamModel, this._liveStreamRepository)
    : super(const LiveStreamState());

  Future<void> initAgora() async {
    emit(state.copyWith(status: LiveStreamStatus.loading));
    try {
      await [Permission.camera, Permission.microphone].request();

      engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(
          appId: dotenv.env['AGORA_APP_ID']!,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
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

  Future<void> endStream(BuildContext context) async {
    final res = await _liveStreamRepository.endStream(streamModel.id);
    res.fold(
      (error) => emit(state.copyWith(status: LiveStreamStatus.failure)),
      (unit) async {
        await engine.leaveChannel();
        await engine.release();
        if (context.mounted) Navigator.pop(context);
      },
    );
    emit(state.copyWith(isLive: false));
  }

  @override
  Future<void> close() {
    engine.leaveChannel();
    engine.release();
    return super.close();
  }
}
