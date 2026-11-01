import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Signature Gatishil / Bangladesh Railway Emerald Forest Palette
  static const Color primary = Color(0xFF0D5C3A); // Deep Railway Green
  static const Color primaryDark = Color(0xFF073B24);
  static const Color primaryLight = Color(0xFFE8F5E9); // Mint surface
  static const Color accentAmber = Color(0xFFD97706); // Amber / Honey Accent
  static const Color accentGold = Color(0xFFF59E0B);
  
  // Status Colors
  static const Color lateRed = Color(0xFFDC2626); // Delay crimson
  static const Color onTimeGreen = Color(0xFF16A34A); // On-time green
  static const Color etaBlue = Color(0xFF0284C7); // Blue ETA chips
  static const Color alertOrange = Color(0xFFEA580C);
  
  // Surfaces & Neutrals
  static const Color background = Color(0xFFF8FAFC); // Crisp slate-white paper
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color slateDark = Color(0xFF0F172A); // Heading text
  static const Color slateText = Color(0xFF334155); // Body text
  static const Color slateMuted = Color(0xFF64748B); // Subtitle / hint
  static const Color dividerColor = Color(0xFFE2E8F0);

  // Backward-compatible aliases for existing components
  static const Color primaryGreen = primary;
  static const Color lightGreen = primaryLight;
  static const Color textDark = slateDark;
  static const Color textMuted = slateMuted;
  static const Color backgroundGrey = background;
  static const Color accentOrange = accentAmber;
  
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.hindSiliguriTextTheme().copyWith(
      displayLarge: GoogleFonts.hindSiliguri(fontSize: 28, fontWeight: FontWeight.bold, color: slateDark),
      displayMedium: GoogleFonts.hindSiliguri(fontSize: 24, fontWeight: FontWeight.bold, color: slateDark),
      titleLarge: GoogleFonts.hindSiliguri(fontSize: 20, fontWeight: FontWeight.bold, color: slateDark),
      titleMedium: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.w600, color: slateDark),
      titleSmall: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.w600, color: slateDark),
      bodyLarge: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.normal, color: slateText),
      bodyMedium: GoogleFonts.hindSiliguri(fontSize: 13, fontWeight: FontWeight.normal, color: slateText),
      bodySmall: GoogleFonts.hindSiliguri(fontSize: 12, fontWeight: FontWeight.normal, color: slateMuted),
      labelLarge: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryLight,
        onPrimaryContainer: primaryDark,
        secondary: accentAmber,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: slateDark,
        error: lateRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.hindSiliguri(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.hindSiliguri(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.8),
        ),
        hintStyle: GoogleFonts.hindSiliguri(color: slateMuted, fontSize: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: slateMuted,
        selectedLabelStyle: GoogleFonts.hindSiliguri(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.hindSiliguri(fontSize: 11, fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
