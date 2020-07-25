import 'package:flutter/material.dart';

// https://rxlabz.github.io/panache/#/editor

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.teal[300],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'QuickSand',
  scaffoldBackgroundColor: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.teal[300],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'QuickSand',
  scaffoldBackgroundColor: Colors.grey[800],
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