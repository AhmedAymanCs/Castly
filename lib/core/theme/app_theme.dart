import 'package:flutter/material.dart';
import 'package:castly/core/constants/color_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ColorManager.coralPrimary,
      secondary: ColorManager.gray500,
      surface: ColorManager.backgroundWhite,
      onPrimary: ColorManager.textLight,
      onSecondary: ColorManager.textLight,
    ),
    scaffoldBackgroundColor: ColorManager.backgroundWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.backgroundWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorManager.textPrimary),
      titleTextStyle: TextStyle(
        color: ColorManager.textHeading,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.coralPrimary,
        foregroundColor: ColorManager.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ColorManager.coralPrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.error),
      ),
      hintStyle: const TextStyle(color: ColorManager.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: ColorManager.backgroundWhite,
      elevation: 2,
      shadowColor: ColorManager.overlayBlack10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: ColorManager.divider,
      thickness: 1,
    ),
  );
}
