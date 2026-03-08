import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Screen / scaffold backgrounds ─────────────────────────────────────────
  static const Color primaryDark  = Color(0xFF0B1929);
  static const Color navyMid      = Color(0xFF0F2237);
  static const Color accentBlue   = Color(0xFF2563EB);

  // ── Input / login helpers ─────────────────────────────────────────────────
  static const Color inputBg      = Color(0xFFF3F4F6);
  static const Color borderColor  = Color(0xFFE5E7EB);
  static const Color textGrey     = Color(0xFF6B7280);
  static const Color cardWhite    = Color(0xFFFFFFFF);

  // ── Profile card colours — WHITE card, matches screenshot ─────────────────
  // profile_widget.dart uses these three for card body, header strip & border
  static const Color darkCard     = Color(0xFFFFFFFF);   // card background → white
  static const Color darkSurface  = Color(0xFFF8F9FB);   // header strip → off-white
  static const Color darkBorder   = Color(0xFFE5E7EB);   // card border → light grey

  // ── Shadow (soft, appropriate for white cards on dark bg) ─────────────────
  static List<BoxShadow> get cardShadow => const [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

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
        backgroundColor: const Color(0xFF0B1929),
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