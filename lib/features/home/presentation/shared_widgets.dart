import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/widgets/cutom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final String title;
  final int viewerCount;
  final VoidCallback onTap;

  const StreamCard({
    super.key,
    required this.thumbnailUrl,
    required this.streamerName,
    required this.title,
    required this.viewerCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
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
                      errorBuilder: (_, _, _) => Container(
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
            const SizedBox(width: 10),
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

            // Info row
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

class GoLiveSheet extends StatefulWidget {
  final Function(String title) onGoLive;
  const GoLiveSheet({super.key, required this.onGoLive});

  @override
  State<GoLiveSheet> createState() => _GoLiveSheetState();
}

class _GoLiveSheetState extends State<GoLiveSheet> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Go Live',
            style: TextStyle(
              fontSize: FontSize.s20,
              fontWeight: FontWeight.bold,
              color: ColorManager.textHeading,
            ),
          ),
          SizedBox(height: 20.h),
          // Title
          CustomFormField(
            controller: _titleController,
            hint: 'Stream title...',
            preicon: Icons.live_tv_outlined,
          ),
          SizedBox(height: 24.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorManager.gray200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    StringManager.cancel,
                    style: TextStyle(color: ColorManager.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                        msg: StringManager.enterTitle,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: FontSize.s12,
                      );
                      return;
                    }

                    Navigator.pop(context);
                    widget.onGoLive(_titleController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.coralPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    StringManager.goLive,
                    style: TextStyle(
                      color: ColorManager.backgroundWhite,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
