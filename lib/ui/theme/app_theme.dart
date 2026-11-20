import 'package:flutter/material.dart';

enum ButtonType { number, operator, action, scientific, equals, memory }

class AppTheme {
  // Exact Logo Colors (Deep Royal Burgundy & Metallic Gold)
  static const Color deepBurgundy = Color(0xFF58000F);
  static const Color royalMaroon = Color(0xFF6B0014);
  static const Color metallicGold = Color(0xFFD4AF37);
  static const Color warmGold = Color(0xFFC59B27);
  static const Color brightGold = Color(0xFFE5C158);

  // Aliases for compatibility
  static const Color primaryBlue = metallicGold;
  static const Color primaryOrange = brightGold;
  static const Color primaryGold = metallicGold;

  // Dark Theme Palette (Burgundy & Gold matching logo)
  static const Color darkBackground = Color(0xFF38000A); // Deep Royal Burgundy
  static const Color darkSurface = Color(0xFF520A16);
  static const Color darkNumBtn = Color(0xFF5E0D1B);
  static const Color darkOperatorBtn = Color(0xFF751524);
  static const Color darkScientificBtn = Color(0xFF6B121F);
  static const Color darkActionBtn = Color(0xFF821C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFF3D77B); // Gold tint

  // Light Theme Palette (Warm Cream & Burgundy)
  static const Color lightBackground = Color(0xFFFAF6F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightNumBtn = Color(0xFFFFFFFF);
  static const Color lightOperatorBtn = Color(0xFFEFE4DA);
  static const Color lightScientificBtn = Color(0xFFE5D8CC);
  static const Color lightActionBtn = Color(0xFFD6C8BB);
  static const Color lightTextPrimary = Color(0xFF38000A);
  static const Color lightTextSecondary = Color(0xFF8A6235);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      surface: lightSurface,
      primary: metallicGold,
      secondary: brightGold,
      onSurface: lightTextPrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      surface: darkSurface,
      primary: metallicGold,
      secondary: brightGold,
      onSurface: darkTextPrimary,
    ),
  );

  static Color getButtonBgColor(BuildContext context, ButtonType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (type) {
      case ButtonType.number:
        return isDark ? darkNumBtn : lightNumBtn;
      case ButtonType.operator:
        return isDark ? darkOperatorBtn : lightOperatorBtn;
      case ButtonType.scientific:
        return isDark ? darkScientificBtn : lightScientificBtn;
      case ButtonType.action:
        return isDark ? darkActionBtn : lightActionBtn;
      case ButtonType.memory:
        return isDark ? const Color(0xFF4A0813) : const Color(0xFFE2D2C3);
      case ButtonType.equals:
        return metallicGold; // Metallic gold equals button
    }
  }

  static Color getButtonTextColor(BuildContext context, ButtonType type) {
    if (type == ButtonType.equals) {
      return deepBurgundy; // Rich burgundy text on gold equals button
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (type == ButtonType.operator || type == ButtonType.action || type == ButtonType.memory) {
      return isDark ? brightGold : deepBurgundy;
    }
    if (type == ButtonType.scientific) {
      return isDark ? brightGold : deepBurgundy;
    }
    return isDark ? darkTextPrimary : lightTextPrimary;
  }
}
