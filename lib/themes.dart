import 'package:flutter/material.dart';

// https://rxlabz.github.io/panache/#/editor

ThemeData lightTheme(BuildContext context) => ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.teal[300],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'QuickSand',
  scaffoldBackgroundColor: Colors.white,
  buttonTheme: ButtonTheme.of(context).copyWith(
    buttonColor: Colors.teal[300],
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  )
);

ThemeData darkTheme(BuildContext context) => ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[900],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.teal[300],
  accentColorBrightness: Brightness.dark,
  fontFamily: 'QuickSand',
  scaffoldBackgroundColor: Colors.grey[800],
    buttonTheme: ButtonTheme.of(context).copyWith(
      buttonColor: Colors.teal[300],
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    )
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