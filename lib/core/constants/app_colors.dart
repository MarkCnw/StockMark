import 'package:flutter/material.dart';

/// App Colors - Single Source of Truth
class AppColors {
  AppColors._();

  // ===== PRIMARY =====
  static const Color primaryBlue = Color(0xFF2B6BE5);
  static const Color primaryBlueLight = Color(0xFF64B5F6);

  // ===== BACKGROUND =====
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color darkBg = Color(0xFF121212);

  // ===== SURFACE / CARD =====
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // ===== NAVIGATION =====
  static const Color navBgLight = Color(0xFFF4F8FC);
  static const Color navBgDark = Color(0xFF0F1115);
  static const Color navActiveLight = Color(0xFF2B6BE5);
  static const Color navActiveDark = Color(0xFF64B5F6);

  // ===== TEXT =====
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF616161);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color textTertiaryDark = Color(0xFF757575);

  // ✅ เพิ่มชื่อที่โค้ดเรียกใช้ (Alias)
  static const Color lightTextPrimary = textPrimaryLight;
  static const Color darkTextPrimary = textPrimaryDark;
  static const Color lightTextSecondary = textSecondaryLight;
  static const Color darkTextSecondary = textSecondaryDark;

  // ===== DIVIDER =====
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // ===== BORDER =====
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF3D3D3D);

  // ===== TAB / BUTTON =====
  static const Color lightTabUnselected = Color(0xFFF0F0F0);
  static const Color darkTabUnselected = Color(0xFF2A2A2A);

  // ===== ICON BACKGROUND =====
  static const Color lightIconBg = Color(0xFFE8E8E8);
  static const Color darkIconBg = Color(0xFF3A3A3A);

  // ===== STATUS =====
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // ===== STOCK =====
  static const Color stockUp = Color(0xFF00C853);
  static const Color stockDown = Color(0xFFFF3D00);

  // ===== HOT / ACCENT =====
  static const Color hotBadge = Color(0xFFE53935);
  static const Color accent = Color(0xFF2196F3);
}