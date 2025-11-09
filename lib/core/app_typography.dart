import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    )
  );
}
