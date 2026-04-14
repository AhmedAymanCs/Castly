import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/router/routes.dart';
import 'package:castly/features/home/data/repository/repositroy.dart';
import 'package:castly/features/home/logic/cubit.dart';
import 'package:castly/features/home/logic/state.dart';
import 'package:castly/features/home/presentation/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeCubit(getIt<HomeRepository>(), getIt<FirebaseAuth>())
            ..getCurrentStreams(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.failure) {
            Fluttertoast.showToast(
              msg: state.errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: FontSize.s12,
            );
          }
          if (state.status == HomeStatus.createStreamSuccess) {
            Navigator.pushNamed(
              context,
              Routes.liveStream,
              arguments: state.liveStreamModel,
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<HomeCubit>();
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
                  icon: const Icon(
                    Icons.person_outline,
                    color: ColorManager.gray900,
                  ),
                  onPressed: () => Navigator.pushNamed(context, Routes.profile),
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
                      itemCount: state.streams.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return StreamCard(
                          thumbnailUrl: state.streams[index].thumbnailUrl,
                          streamerName: state.streams[index].streamerName,
                          title: state.streams[index].title,
                          viewerCount: state.streams[index].viewerCount,
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.watchStream,
                            arguments: state.streams[index],
                          ),
                        );
                      },
                    ),
                  ),
                  // Go Live Button
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: const BoxDecoration(
                      color: ColorManager.backgroundWhite,
                      border: Border(
                        top: BorderSide(color: ColorManager.gray200),
                      ),
                    ),
                    child: GoLiveButton(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: ColorManager.backgroundWhite,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => GoLiveSheet(
                            onGoLive: (title) => cubit.createStream(title),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
