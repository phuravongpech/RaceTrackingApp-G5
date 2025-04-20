import 'package:flutter/material.dart';

class RTColors {
  // Base palette
  static const Color primary = Color(0xFF0A84FF); // iOS-style blue
  static const Color secondary = Color(0xFF5E5CE6); // Soft indigo
  static const Color tertiary = Color(
    0xFF30D158,
  ); // Green accent (for actions or highlights)

  static const Color backgroundAccent = Color(
    0xFFF2F2F7,
  ); // Light grey background
  static const Color white = Colors.white;
  static const Color black = Color(0xFF000000);

  // Status colors
  static const Color error = Color(0xFFFF3B30); // Standard red
  static const Color success = Color(0xFF32D74B); // Standard green
  static const Color warning = Color(0xFFFF9F0A); // Amber/orange

  // Text
  static const Color textPrimary = Color(0xFF1C1C1E); // Near-black
  static const Color textSecondary = Color(0xFF8E8E93); // iOS grey
}

class RTTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: RTColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
    fontFamily: 'Poppins',
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: RTColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.4,
    fontFamily: 'Poppins',
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: RTColors.textPrimary,
    height: 1.5,
    fontFamily: 'Poppins',
  );

  static const TextStyle subBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: RTColors.textSecondary,
    height: 1.4,
    fontFamily: 'Poppins',
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: RTColors.textSecondary,
    letterSpacing: 0.15,
    fontFamily: 'Poppins',
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: RTColors.white,
    letterSpacing: 1.25,
    fontFamily: 'Poppins',
  );
}

ThemeData appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: RTColors.primary,
  scaffoldBackgroundColor: RTColors.white,
  colorScheme: ColorScheme.light(
    primary: RTColors.primary,
    secondary: RTColors.secondary,
    error: RTColors.error,
    background: RTColors.backgroundAccent,
    onPrimary: RTColors.white,
    onSecondary: RTColors.black,
    onError: RTColors.white,
    onBackground: RTColors.textPrimary,
    surface: RTColors.white,
    onSurface: RTColors.textPrimary,
  ),
  textTheme: TextTheme(
    titleLarge: RTTextStyles.heading,
    titleMedium: RTTextStyles.title,
    bodyLarge: RTTextStyles.body,
    bodyMedium: RTTextStyles.subBody,
    bodySmall: RTTextStyles.label,
    labelLarge: RTTextStyles.button,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RTColors.primary,
      foregroundColor: RTColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: RTTextStyles.button,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: RTColors.primary,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: RTColors.backgroundAccent,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    labelStyle: RTTextStyles.label,
  ),
  cardTheme: CardTheme(
    color: RTColors.backgroundAccent,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: RTColors.white,
    foregroundColor: RTColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: RTTextStyles.heading.copyWith(fontSize: 24),
    iconTheme: const IconThemeData(color: RTColors.textPrimary, size: 30),
    shadowColor: RTColors.textSecondary,
  ),
);
