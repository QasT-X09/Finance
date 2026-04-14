import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgTop = Color(0xFF0B1020);
  static const Color bgBottom = Color(0xFF141627);
  static const Color card = Color(0xFF0F1724);
  static const Color accent = Color(0xFF6C7CFF);
  static const Color accent2 = Color(0xFF4A3DFF);

  static ThemeData darkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: bgBottom,
      primaryColor: accent,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent2,
        background: bgBottom,
        surface: card,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgTop,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      // cardTheme and dialogTheme can be customized per platform/version if needed
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white,
      ),
    );
  }
}
