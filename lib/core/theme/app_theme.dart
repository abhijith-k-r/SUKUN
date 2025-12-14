// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/theme/app_spacing.dart';

class AppTheme {
  static TextTheme _createPoppinsTextTheme(
    TextTheme baseTextTheme, {
    required Color bodyColor,
    required Color displayColor,
  }) {
    return GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontFamilyFallback: GoogleFonts.poppins().fontFamilyFallback,
      bodyColor: bodyColor,
      displayColor: displayColor,
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: AppColors.primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        secondary: AppColors.accentYellow,
        background: AppColors.lightBg,
      ),

      textTheme:
          _createPoppinsTextTheme(
            base.textTheme,
            bodyColor: AppColors.black,
            displayColor: AppColors.black,
          ).copyWith(
            // headlineLarge: const TextStyle(
            //   fontSize: 26,
            //   fontWeight: FontWeight.w700,
            //   inherit: true,
            // ),
            // headlineMedium: const TextStyle(
            //   fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //   inherit: true,
            // ),
            // bodyMedium: const TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.w400,
            //   inherit: true,
            // ),
            // bodySmall: const TextStyle(
            //   fontSize: 12,
            //   fontWeight: FontWeight.w400,
            //   inherit: true,
            // ),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              inherit: true,
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
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
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            inherit: true,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            inherit: true,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.lighblackBg,
      primaryColor: AppColors.primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentYellow,
        background: AppColors.darkBg,
        error: AppColors.error,
      ),

      textTheme:
          _createPoppinsTextTheme(
            base.textTheme,
            bodyColor: AppColors.white,
            displayColor: AppColors.white,
          ).copyWith(
            // headlineLarge: const TextStyle(
            //   fontSize: 26,
            //   fontWeight: FontWeight.w700,
            //   inherit: true,
            // ),
            // headlineMedium: const TextStyle(
            //   fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //   inherit: true,
            // ),
            // bodyMedium: const TextStyle(
            //   fontSize: 14,
            //   fontWeight: FontWeight.w400,
            //   inherit: true,
            // ),
            // bodySmall: const TextStyle(
            //   fontSize: 12,
            //   fontWeight: FontWeight.w400,
            //   inherit: true,
            // ),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              inherit: true,
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 65, 65, 65),
        elevation: 0,
        foregroundColor: AppColors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentYellow,
          foregroundColor: AppColors.black,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            inherit: true,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            inherit: true,
          ),
        ),
      ),
    );
  }
}
