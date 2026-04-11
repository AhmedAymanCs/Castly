import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.coralPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: ColorManager.backgroundWhite,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            StringManager.live,
            style: TextStyle(
              color: ColorManager.backgroundWhite,
              fontSize: FontSize.s12,
              fontWeight: FontWeightManager.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewerCount extends StatelessWidget {
  final int count;

  const ViewerCount({super.key, required this.count});

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.overlayBlack50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.remove_red_eye_outlined,
            color: ColorManager.backgroundWhite,
            size: 13,
          ),
          const SizedBox(width: 4),
          Text(
            _format(count),
            style: TextStyle(
              color: ColorManager.backgroundWhite,
              fontSize: FontSize.s12,
              fontWeight: FontWeightManager.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StreamCard extends StatelessWidget {
  final String thumbnailUrl;
  final String streamerName;
  final String streamerAvatar;
  final String title;
  final int viewerCount;
  final VoidCallback onTap;

  const StreamCard({
    super.key,
    required this.thumbnailUrl,
    required this.streamerName,
    required this.streamerAvatar,
    required this.title,
    required this.viewerCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ColorManager.overlayBlack10,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: ColorManager.backgroundGray100,
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: ColorManager.gray400,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(top: 8, left: 8, child: const LiveBadge()),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ViewerCount(count: viewerCount),
                    ),
                  ],
                ),
              ),
            ),

            // Info row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(streamerAvatar),
                    backgroundColor: ColorManager.backgroundGray100,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            fontWeight: FontWeightManager.bold,
                            color: ColorManager.textHeading,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          streamerName,
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoLiveButton extends StatelessWidget {
  final VoidCallback onTap;
  const GoLiveButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: ColorManager.coralPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_rounded,
              color: ColorManager.backgroundWhite,
              size: 22,
            ),
            SizedBox(width: 8.w),
            Text(
              StringManager.goLive,
              style: TextStyle(
                color: ColorManager.backgroundWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
