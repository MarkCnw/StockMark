

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightBg,
    textTheme: AppTypography.light,
    dividerColor: AppColors.dividerLight,
    navigationBarTheme: _navigationBarTheme(isDark: false),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness. dark,
    colorSchemeSeed: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.darkBg,
    textTheme: AppTypography.dark,
    dividerColor: AppColors.dividerDark,
    navigationBarTheme: _navigationBarTheme(isDark: true),
  );

  static NavigationBarThemeData _navigationBarTheme({required bool isDark}) {
    return NavigationBarThemeData(
      backgroundColor: isDark ? AppColors. navBgDark : AppColors.navBgLight,
      indicatorColor: Colors.transparent,
      overlayColor: WidgetStateProperty. all(Colors.transparent),
      labelTextStyle: WidgetStateProperty. resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppColors. navActiveDark : AppColors.navActiveLight)
              : (isDark ? Colors.white70 : Colors.black87),
        );
      }),
    );
  }
}