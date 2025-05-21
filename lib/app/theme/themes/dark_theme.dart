import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_coconut/app/theme/themes/theme_constants.dart';

final darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: MyColors.darkAccent,
    secondary: MyColors.darkAccent2,
    primaryContainer: MyColors.darkCard,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: MyColors.darkBackground,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: MyColors.darkAccent,
    unselectedItemColor: MyColors.darkAccent2,
    backgroundColor: MyColors.darkBackground,
  ),
  cardTheme: CardTheme(
    color: MyColors.darkCard,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.darkAccent2,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    headlineMedium: GoogleFonts.ptSerif(fontSize: 24, color: Colors.white),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, color: Colors.white),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
