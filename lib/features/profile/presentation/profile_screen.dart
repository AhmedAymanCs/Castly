import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/router/routes.dart';
import 'package:castly/core/theme/cubit/cubit.dart';
import 'package:castly/features/profile/data/repository/repo.dart';
import 'package:castly/features/profile/logic/cubit.dart';
import 'package:castly/features/profile/logic/state.dart';
import 'package:castly/features/profile/presentation/shared_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(getIt<ProfileRepository>())..getUserData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringManager.profile),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ],
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.logout) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (_) => false,
              );
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  ProfileAvatar(
                    imageUrl: state.user.image == '' ? null : state.user.image,
                    name: state.user.name ?? StringManager.notFound,
                  ),
                  SizedBox(height: 24.h),
                  ProfileInfoCard(
                    name: state.user.name ?? StringManager.notFound,
                    email: state.user.email ?? StringManager.notFound,
                  ),
                  SizedBox(height: 15.h),
                  ProfileActionButton(
                    icon: Icons.edit_rounded,
                    label: StringManager.editProfile,
                    onTap: () {
                      final cubit = context.read<ProfileCubit>();
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(cubit: cubit),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileActionButton(
                    icon: Icons.logout_rounded,
                    label: StringManager.logout,
                    color: ColorManager.error,
                    onTap: () => context.read<ProfileCubit>().logout(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
