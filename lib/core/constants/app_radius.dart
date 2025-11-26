import 'package:flutter/material.dart';

/// App Radius - Border radius constants
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double full = 999.0; // สำหรับวงกลม

  // BorderRadius shortcuts
  static BorderRadius get smallAll => BorderRadius.circular(sm);
  static BorderRadius get mediumAll => BorderRadius.circular(md);
  static BorderRadius get largeAll => BorderRadius.circular(lg);
  static BorderRadius get circular => BorderRadius.circular(full);
}