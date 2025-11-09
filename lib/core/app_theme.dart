import 'package:flutter/material.dart';
import 'package:stockmark/core/app_typography.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stockmark/core/constants/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightBg,
    textTheme: AppTypography.lightTextTheme,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFF4F8FC),
      indicatorColor: Colors.transparent,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),

      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2B6BE5), // active
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87, // normal
        );
      }),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.blueAccent,
    textTheme: AppTypography.darkTextTheme,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0F1115),
      indicatorColor: Colors.transparent,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),

      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64B5F6), // active
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white70, // normal
        );
      }),
    ),
  );
}
