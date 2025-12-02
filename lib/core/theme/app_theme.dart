// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/theme/app_spacing.dart';
import 'package:sukun/core/theme/app_typography.dart';

// app_theme.dart
class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentYellow,
        background: AppColors.lightBg,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme.copyWith(
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          bodyMedium: AppTypography.body,
          labelLarge: AppTypography.button,
          bodySmall: AppTypography.caption,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.buttonRadius,
          borderSide: BorderSide(color: AppColors.grey500, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentYellow,
          foregroundColor: AppColors.black,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xl,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonRadius,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentYellow,
        background: AppColors.darkBg,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme.copyWith(
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          bodyMedium: AppTypography.body,
          labelLarge: AppTypography.button,
          bodySmall: AppTypography.caption,
        ),
      ),
    );
  }
}
