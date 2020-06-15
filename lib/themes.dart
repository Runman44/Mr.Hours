import 'package:flutter/material.dart';

// https://rxlabz.github.io/panache/#/editor

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  primaryColor: Colors.deepPurple[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.purple,
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  //scaffoldBackgroundColor: Colors.grey[100],
  scaffoldBackgroundColor: Colors.white,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.deepPurple[50],
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  primaryColor: Colors.deepPurple[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.cyan[600],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  scaffoldBackgroundColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[850],
  ),
);
