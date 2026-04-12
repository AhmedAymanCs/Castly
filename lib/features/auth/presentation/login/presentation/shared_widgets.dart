import 'package:castly/core/constants/font_manager.dart';
import 'package:castly/core/constants/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:castly/core/constants/color_manager.dart';
import 'package:castly/core/constants/string_manager.dart';

class RememberMeAndForgotPassRow extends StatelessWidget {
  final bool rememberMeValue;
  final Function(bool?) checkBoxOnPressed;
  final Function() forgotPassOnPressed;
  const RememberMeAndForgotPassRow({
    super.key,
    required this.rememberMeValue,
    required this.checkBoxOnPressed,
    required this.forgotPassOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          value: rememberMeValue,
          onChanged: (value) => checkBoxOnPressed(value),
          activeColor: ColorManager.primaryColor,
        ),
        Text(StringManager.rememberMe),
        Spacer(),
        TextButton(
          onPressed: forgotPassOnPressed,
          child: Text('${StringManager.forgotPassword}?'),
        ),
      ],
    );
  }
}

class RegisterRow extends StatelessWidget {
  final VoidCallback? onPressed;
  const RegisterRow({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(StringManager.dontHaveAccount),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: onPressed,
          child: Text(StringManager.signUp),
        ),
      ],
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ColorManager.gray200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageManager.google, width: 22, height: 22),
          const SizedBox(width: 10),
          Text(
            StringManager.continueWithGoogle,
            style: TextStyle(
              color: ColorManager.textHeading,
              fontSize: FontSize.s14,
              fontWeight: FontWeightManager.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
