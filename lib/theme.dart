import 'package:flutter/material.dart';

abstract final class GoMitraColors {
  static const green = Color(0xFF16A34A);
  static const forestGreen = Color(0xFF0B3D2E);
  static const greenDark = Color(0xFF0B3D2E);
  static const ink = Color(0xFF111827);
  static const canvas = Color(0xFFF7F9F8);
  static const white = Color(0xFFFFFFFF);
  static const softGreen = Color(0xFFE8F7ED);
  static const mint = Color(0xFFE8F7ED);
  static const blue = Color(0xFF3079E8);
  static const muted = Color(0xFF6B756F);
  static const border = Color(0xFFE1E7E3);
  static const success = Color(0xFF15803D);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFDC2626);
  static const red = Color(0xFFDC2626);
  static const disabledSurface = Color(0xFFEEF1EF);
  static const amber = Color(0xFFF59E0B);
}

ThemeData buildGoMitraTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: GoMitraColors.green,
    primary: GoMitraColors.green,
    surface: GoMitraColors.white,
    error: GoMitraColors.error,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: GoMitraColors.canvas,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: GoMitraColors.canvas,
      foregroundColor: GoMitraColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: GoMitraColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: GoMitraColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: GoMitraColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GoMitraColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: const TextStyle(color: GoMitraColors.muted, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GoMitraColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GoMitraColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GoMitraColors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GoMitraColors.error),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: GoMitraColors.green,
        foregroundColor: GoMitraColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: GoMitraColors.forestGreen,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: GoMitraColors.white,
      selectedItemColor: GoMitraColors.green,
      unselectedItemColor: GoMitraColors.muted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 8,
    ),
  );
}
