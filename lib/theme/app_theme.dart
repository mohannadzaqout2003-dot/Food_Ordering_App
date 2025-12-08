import 'package:flutter/material.dart';

class AppColors {
  // ===================== LIGHT MODE COLORS =====================
  static const Color primaryLight = Color(0xFF007BFF); // Blue
  static const Color secondaryLight = Color(0xFFFF9800); // Orange
  static const Color accentLight = Color(0xFFFF4081); // Pink
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light Gray
  static const Color surfaceLight = Colors.white;

  // ===================== DARK MODE COLORS =====================
  static const Color primaryDark = Color(0xFF008B5B); // Dark Green
  static const Color secondaryDark = Color(0xFFFFC107); // Yellow
  static const Color accentDark = Color(0xFFFFEB3B); // Yellow Accent
  static const Color backgroundDark = Color(0xFF121212); // Dark Background
  static const Color surfaceDark = Color(0xFF1D1D1D); // Dark Surface
}

class AppTheme {
  // =========================== LIGHT THEME ===========================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.surfaceLight,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  // =========================== DARK THEME ===========================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.surfaceDark,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}
