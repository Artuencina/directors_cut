import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Tema principal color azul
final ThemeData mainTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  splashColor: Colors.blueGrey,
  fontFamily: GoogleFonts.roboto().fontFamily,
  textTheme: GoogleFonts.robotoTextTheme(),
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue, brightness: Brightness.light),
);
