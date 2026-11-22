import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF008A55);
  static const Color darkGreen = Color(0xFF075238);
  static const Color lightGreen = Color(0xFFEAF7F0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF111827);
  static const Color mutedText = Color(0xFF6B7280);
  static const Color background = Color(0xFFF7FAF8);
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color warningAmber = Color(0xFFD97706);

  static const Color safaricomGreen = Color(0xFF008A55);
  static const Color airtelRed = Color(0xFFE11D48);
  static const Color telkomBlue = Color(0xFF0284C7);
  static const Color faibaGold = Color(0xFFB45309);
}

class AppBusinessInfo {
  static const String appName = 'BINGWA SOKONI DATA SWIFT';
  static const String businessName = 'BINGWA SOKONI DATA SWIFT';
  static const String tagline = 'Bundles and airtime that keep you connected.';
  static const String tillNumber = '1765260';
  static const String supportPhone = '01812424100';
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.darkGreen,
        surface: AppColors.white,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
        ),
      ),
    );
  }
}
