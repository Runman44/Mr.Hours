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
        buttonColor: Colors.teal[600],
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      cardTheme: CardTheme.of(context).copyWith(
        color: Colors.grey[200],
      ),
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
        buttonColor: Colors.teal[600],
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      cardTheme: CardTheme.of(context).copyWith(
        color: Colors.grey[700],
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
