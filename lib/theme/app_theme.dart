import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryDark  = Color(0xFF0B1929);
  static const Color navyMid      = Color(0xFF0F2237);
  static const Color accentBlue   = Color(0xFF2563EB);
  static const Color inputBg      = Color(0xFFF3F4F6);
  static const Color borderColor  = Color(0xFFE5E7EB);
  static const Color textGrey     = Color(0xFF6B7280);
  static const Color cardWhite    = Color(0xFFFFFFFF);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        surface: primaryDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF0B1929),
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}