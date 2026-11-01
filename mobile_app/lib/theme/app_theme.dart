import 'package:flutter/material.dart';

class AppTheme {
  // Signature Gatishil Crimson/Magenta Brand Colors
  static const Color primary = Color(0xFFC2185B);
  static const Color primaryDark = Color(0xFF880E4F);
  static const Color primaryLight = Color(0xFFD81B60);
  static const Color primarySoft = Color(0xFFFCE4EC);

  // Gradient for curved headers
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD81B60), Color(0xFFC2185B), Color(0xFF880E4F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent and Category Colors
  static const Color accentMint = Color(0xFF0D9488);
  static const Color accentAmber = Color(0xFFD97706);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentBlue = Color(0xFF0284C7);
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color statusGreen = Color(0xFF16A34A);
  static const Color statusRed = Color(0xFFDC2626);
  static const Color statusBlue = Color(0xFF2563EB);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Typography Palette
  static const Color textDark = Color(0xFF0F172A);
  static const Color textBody = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Aliases for backward compatibility
  static const Color primaryGreen = primary;
  static const Color darkGreen = primaryDark;
  static const Color lightGreen = primarySoft;
  static const Color accentOrange = accentAmber;
  static const Color lateRed = statusRed;
  static const Color lightGrey = surfaceVariant;
  static const Color slateDark = textDark;
  static const Color slateMuted = textMuted;
  static const Color slateLight = textLight;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HindSiliguri',
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accentMint,
        surface: surface,
        error: statusRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 0.8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        selectedLabelStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
