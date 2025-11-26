import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_colors.dart';

/// Extension สำหรับ BuildContext
/// ช่วยให้เรียกใช้ Design System ได้ง่ายขึ้น
extension ContextExtensions on BuildContext {
  // ===== THEME =====
  ThemeData get theme => Theme.of(this);
  bool get isDark => theme.brightness == Brightness.dark;

  // ===== COLORS =====
  Color get backgroundColor =>
      isDark ? AppColors.darkBg : AppColors.lightBg;

  Color get cardColor => isDark ? AppColors.darkCard : AppColors.lightCard;

  Color get textPrimaryColor =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  Color get textSecondaryColor =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  Color get dividerColor =>
      isDark ? AppColors.dividerDark : AppColors.dividerLight;

  // ===== TEXT STYLES =====
  TextStyle get headlineLarge =>
      AppTextStyles.headlineLarge(isDark: isDark);
  TextStyle get headlineMedium =>
      AppTextStyles.headlineMedium(isDark: isDark);
  TextStyle get headlineSmall =>
      AppTextStyles.headlineSmall(isDark: isDark);

  TextStyle get titleLarge => AppTextStyles.titleLarge(isDark: isDark);
  TextStyle get titleMedium => AppTextStyles.titleMedium(isDark: isDark);
  TextStyle get titleSmall => AppTextStyles.titleSmall(isDark: isDark);

  TextStyle get bodyLarge => AppTextStyles.bodyLarge(isDark: isDark);
  TextStyle get bodyMedium => AppTextStyles.bodyMedium(isDark: isDark);
  TextStyle get bodySmall => AppTextStyles.bodySmall(isDark: isDark);

  TextStyle get labelLarge => AppTextStyles.labelLarge(isDark: isDark);
  TextStyle get labelMedium => AppTextStyles.labelMedium(isDark: isDark);
  TextStyle get labelSmall => AppTextStyles.labelSmall(isDark: isDark);

  // ===== SCREEN SIZE =====
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
