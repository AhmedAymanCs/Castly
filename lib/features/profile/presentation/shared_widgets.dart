import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/constants/image_manager.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/widgets/custom_button.dart';
import 'package:castly/core/widgets/cutom_form_field.dart';
import 'package:castly/features/profile/data/models/update_model.dart';
import 'package:castly/features/profile/logic/cubit.dart';
import 'package:castly/features/profile/logic/state.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  const ProfileAvatar({super.key, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40),
                )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeightManager.bold,
          ),
        ),
      ],
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String email;
  const ProfileInfoCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ProfileInfoRow(
            icon: Icons.person_rounded,
            label: 'Name',
            value: name,
          ),
          const Divider(height: 20),
          ProfileInfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: email,
          ),
        ],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorManager.gray500),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: ColorManager.gray500)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeightManager.medium),
        ),
      ],
    );
  }
}

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeightManager.medium,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: ColorManager.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final ProfileCubit cubit;
  const EditProfileDialog({super.key, required this.cubit});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state.status == ProfileStatus.updated) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: StringManager.profileUpdated,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorManager.success,
            textColor: ColorManager.backgroundLight,
            fontSize: 16.0,
          );
        }
        if (state.status == ProfileStatus.error) {
          Fluttertoast.showToast(
            msg: StringManager.checkYourInternet,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorManager.error,
            textColor: ColorManager.backgroundLight,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  child: state.file == null
                      ? Image.asset(
                          ImageManager.placeholder,
                          fit: BoxFit.contain,
                        )
                      : Image.file(File(state.file!.path), fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: StringManager.camera,
                        onPressed: () =>
                            widget.cubit.pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: StringManager.gallery,
                        onPressed: () =>
                            widget.cubit.pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20,
                ),
                child: CustomFormField(
                  hint: 'New Name',
                  controller: _nameController,
                ),
              ),
              CustomButton(
                text: 'Update',
                onPressed: () => widget.cubit.updateUserData(
                  UpdateModel(
                    name: _nameController.text == ''
                        ? null
                        : _nameController.text,
                    image: state.file == null ? null : File(state.file!.path),
                  ),
                ),
              ),

              SizedBox(height: 15.h),
            ],
          ),
        );
      },
    );
  }
}
