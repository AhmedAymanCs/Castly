import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/features/streams/live_stream/logic/cubit.dart';
import 'package:castly/features/streams/live_stream/logic/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamCubit, LiveStreamState>(
      builder: (context, state) {
        final cubit = context.read<LiveStreamCubit>();
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Camera preview
              if (state.isLive)
                AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: cubit.engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
              else
                const SizedBox.expand(),
              // Top bar
              Positioned(
                top: 48,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    if (state.isLive)
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
                            Icon(Icons.circle, color: Colors.white, size: 8),
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
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await cubit.endStream();
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.coralPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'End',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stream title
              Positioned(
                top: 100,
                left: 16,
                child: Text(
                  cubit.streamModel.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: cubit.toggleMic,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          state.micMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator
              if (state.status == LiveStreamStatus.loading)
                const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.coralPrimary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
