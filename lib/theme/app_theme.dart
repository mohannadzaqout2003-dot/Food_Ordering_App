import 'package:flutter/material.dart';

class AppColors {
  // ===================== BRAND COLORS =====================
  // Calm premium palette for food apps
  static const Color primaryLight = Color(0xFF0F766E); // Deep Teal
  static const Color secondaryLight = Color(0xFFF59E0B); // Warm Amber
  static const Color accentLight = Color(0xFFF97316); // Soft Coral / Orange

  static const Color primaryDark = Color(
    0xFF2DD4BF,
  ); // Teal Mint (better contrast on dark)
  static const Color secondaryDark = Color(0xFFFBBF24); // Amber
  static const Color accentDark = Color(
    0xFFFB7185,
  ); // Soft Rose (nice for favorites)

  // ===================== BACKGROUNDS & SURFACES =====================
  static const Color backgroundLight = Color(0xFFF7F7F8); // soft gray
  static const Color surfaceLight = Color(0xFFFFFFFF); // white cards
  static const Color surfaceAltLight = Color(
    0xFFF1F5F9,
  ); // subtle bluish-gray for chips/containers

  static const Color backgroundDark = Color(0xFF0B1220); // deep navy
  static const Color surfaceDark = Color(0xFF111A2E); // card surface
  static const Color surfaceAltDark = Color(0xFF16213A); // containers

  // ===================== TEXT =====================
  static const Color textPrimaryLight = Color(0xFF0F172A); // slate-900
  static const Color textSecondaryLight = Color(0xFF475569); // slate-600

  static const Color textPrimaryDark = Color(0xFFE5E7EB); // gray-200
  static const Color textSecondaryDark = Color(0xFF9CA3AF); // gray-400

  // ===================== STATES =====================
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF24324F);
}

class AppTheme {
  // =========================== LIGHT THEME ===========================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.secondaryLight,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    ),

    dividerColor: AppColors.dividerLight,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAltLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceAltLight,
      selectedColor: AppColors.primaryLight.withOpacity(0.12),
      labelStyle: const TextStyle(color: AppColors.textPrimaryLight),
      secondaryLabelStyle: const TextStyle(color: AppColors.textPrimaryLight),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );

  // =========================== DARK THEME ===========================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: Color(0xFF062925),
      secondary: AppColors.secondaryDark,
      onSecondary: Color(0xFF2A1B00),
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    ),

    dividerColor: AppColors.dividerDark,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAltDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceAltDark,
      selectedColor: AppColors.primaryDark.withOpacity(0.18),
      labelStyle: const TextStyle(color: AppColors.textPrimaryDark),
      secondaryLabelStyle: const TextStyle(color: AppColors.textPrimaryDark),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: const Color(0xFF062925),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
