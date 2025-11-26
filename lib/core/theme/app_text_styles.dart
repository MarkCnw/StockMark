import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// App Text Styles - Single Source of Truth
/// ใช้สำหรับ Text ทั้งแอพ
class AppTextStyles {
  AppTextStyles._();

  // ===== BASE FONT =====
  static String?  get _fontFamily => GoogleFonts.inter(). fontFamily;

  // ===== HEADLINE =====
  static TextStyle headlineLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle headlineMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle headlineSmall({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  // ===== TITLE =====
  static TextStyle titleLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle titleMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle titleSmall({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  // ===== BODY =====
  static TextStyle bodyLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle bodySmall({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  // ===== LABEL =====
  static TextStyle labelLarge({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight. w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle labelMedium({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle labelSmall({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  // ===== BUTTON =====
  static TextStyle button({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight. w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  // ===== CAPTION =====
  static TextStyle caption({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      );

  // ===== SPECIAL: Stock Price =====
  static TextStyle stockPrice({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle stockChange({required bool isPositive}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isPositive ? AppColors.stockUp : AppColors. stockDown,
      );

  static TextStyle stockSymbol({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors. textPrimaryDark : AppColors.textPrimaryLight,
      );

  // ===== SPECIAL: News =====
  static TextStyle newsTitle({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.4,
        color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
      );

  static TextStyle newsSource({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight. w600,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle newsTime({bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      );
}