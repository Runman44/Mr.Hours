import 'package:flutter/material.dart';

// https://rxlabz.github.io/panache/#/editor

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: Colors.amber[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.amber,
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
  primarySwatch: Colors.red,
  primaryColor: Colors.amber[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.amber,
  accentColorBrightness: Brightness.dark,
  fontFamily: 'PublicSans',
  scaffoldBackgroundColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[850],
  ),
);

final kHintTextStyle = TextStyle(
  color: Colors.deepPurple,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.grey[200],
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);