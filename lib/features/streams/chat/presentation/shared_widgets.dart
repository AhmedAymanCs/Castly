import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/font_manager.dart';
import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final String message;
  final String sender;
  final String? avatarUrl;
  const MessageView({
    super.key,
    required this.message,
    required this.sender,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
              ? NetworkImage(avatarUrl!)
              : null,
          child: avatarUrl == null || avatarUrl!.isEmpty
              ? Text(sender.substring(0, 1).toUpperCase())
              : null,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                color: ColorManager.textLight,
                fontSize: FontSize.s12,
                fontWeight: FontWeightManager.bold,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: ColorManager.border,
                fontSize: FontSize.s12,
                fontWeight: FontWeightManager.regular,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
