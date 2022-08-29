
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: TextTheme(
    headline1: GoogleFonts.vt323(
      fontSize: 35,
      color: Colors.white,
    ),
    button: GoogleFonts.vt323(
      fontSize: 30,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: GoogleFonts.vt323(
      fontSize: 28,
      color: Colors.grey,
    ),
    bodyText2: GoogleFonts.vt323(
      fontSize: 18,
      color: Colors.grey,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.black,
      minimumSize: const Size(150, 50),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hoverColor: Colors.red.shade700,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red.shade700,
      ),
    ),
  ),
);