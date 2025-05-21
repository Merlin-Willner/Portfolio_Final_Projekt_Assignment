import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_coconut/app/theme/themes/theme_constants.dart';

final lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: MyColors.lightAccent2,
    secondary: MyColors.lightAccent,
    surface: MyColors.lightCard,
    primaryContainer: MyColors.lightCard,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: MyColors.lightBackground,
  appBarTheme: AppBarTheme(
    color: MyColors.lightCard,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.ptSerif(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: MyColors.lightAccent,
    unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.7),
    backgroundColor: MyColors.lightBackground,
  ),
  cardTheme: CardTheme(
    color: MyColors.lightCard,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  ),
  textTheme: TextTheme(
    headlineMedium: GoogleFonts.ptSerif(fontSize: 24, color: Colors.black),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MyColors.lightCard,
      foregroundColor: Colors.black,
    ),
  ),
);
