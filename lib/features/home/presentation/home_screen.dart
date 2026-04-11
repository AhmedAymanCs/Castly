import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/features/home/presentation/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:castly/core/constants/color_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringManager.appName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorManager.coralPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: ColorManager.gray900),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: ColorManager.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Streams List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return StreamCard(
                    thumbnailUrl: '',
                    streamerName: 'Streamer Name',
                    streamerAvatar: '',
                    title: 'Stream Title Goes Here',
                    viewerCount: 1200,
                    onTap: () {},
                  );
                },
              ),
            ),
            // Go Live Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: ColorManager.backgroundWhite,
                border: Border(top: BorderSide(color: ColorManager.gray200)),
              ),
              child: GoLiveButton(onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
