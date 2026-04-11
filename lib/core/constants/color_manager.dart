import 'dart:ui';

class ColorManager {
  // Primary Accent
  static const Color coralPrimary = Color(0xFFE8453C);

  // Backgrounds
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundGray100 = Color(0xFFF3F4F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textHeading = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);

  // Grays
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray900 = Color(0xFF1F2937);

  // Borders & Dividers
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE5E7EB);

  // Overlays
  static const Color overlayBlack10 = Color(0x1A000000);
  static const Color overlayBlack40 = Color(0x66000000);
  static const Color overlayBlack50 = Color(0x80000000);
  static const Color overlayBlack60 = Color(0x99000000);
  static const Color overlayBlack70 = Color(0xB3000000);
  static const Color overlayWhite10 = Color(0x1AFFFFFF);
  static const Color overlayWhite20 = Color(0x33FFFFFF);
  static const Color overlayWhite60 = Color(0x99FFFFFF);
  static const Color overlayWhite80 = Color(0xCCFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF34A853);
  static const Color error = Color(0xFFEA4335);
  static const Color warning = Color(0xFFFBBC05);
  static const Color info = Color(0xFF4285F4);

  // Google Button Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  // Video / Stream
  static const Color videoBackground = Color(0xFF000000);

  // Aliases
  static const Color primaryColor = ColorManager.coralPrimary;
  static const Color scaffoldBackgroundColor = ColorManager.backgroundWhite;
  static const Color lightBackground = ColorManager.backgroundLight;
  static const Color lightSurface = ColorManager.backgroundWhite;
  static const Color lightCard = ColorManager.backgroundWhite;
}
