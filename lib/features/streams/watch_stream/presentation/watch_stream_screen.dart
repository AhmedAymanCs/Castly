import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/models/stream_model.dart';
import 'package:castly/features/streams/chat/presentation/chat_view.dart';
import 'package:castly/features/streams/watch_stream/data/repository/repo.dart';
import 'package:castly/features/streams/watch_stream/logic/cubit.dart';
import 'package:castly/features/streams/watch_stream/logic/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatchPage extends StatelessWidget {
  final StreamModel streamModel;
  const WatchPage({super.key, required this.streamModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchCubit, WatchState>(
      builder: (context, state) {
        final cubit = context.read<WatchCubit>();
        return Scaffold(
          backgroundColor: Colors.black,
          body: state.streamEnded
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stream Ended',
                        style: TextStyle(
                          color: ColorManager.coralPrimary,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ColorManager.coralPrimary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Remote video
                    if (state.status == WatchStatus.watching)
                      AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: cubit.engine,
                          canvas: VideoCanvas(uid: state.remoteUid),
                          connection: RtcConnection(channelId: streamModel.id),
                        ),
                      )
                    else
                      const SizedBox.expand(),

                    // Loading
                    if (state.status == WatchStatus.loading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.coralPrimary,
                        ),
                      ),

                    // Top bar
                    Positioned(
                      top: 48,
                      left: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.gray400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Live badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.coralPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                    size: 8,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Streamer name
                            Text(
                              streamModel.streamerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${state.viewerCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Leave button
                            GestureDetector(
                              onTap: () async {
                                await cubit.leaveStream();
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Stream title
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Text(
                        streamModel.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Chat overlay
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      height: 250,
                      child: ChatView(streamId: cubit.streamModel.id),
                    ),
                    // Stream ended
                    if (state.remoteUid == 0 &&
                        state.status == WatchStatus.watching)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_tethering_off_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Stream ended',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.coralPrimary,
                              ),
                              child: const Text('Go Back'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
