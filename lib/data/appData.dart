import 'package:flutter/material.dart';

String appName = 'Cadets Nearby';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  accentColor: Colors.orange,
  backgroundColor: Colors.orange[200],
  bottomAppBarColor: Colors.orange[100],
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Poppins',
    ),
    bodyText2: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline1: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline2: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline3: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline4: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline5: TextStyle(
      fontFamily: 'Poppins',
    ),
    headline6: TextStyle(
      fontFamily: 'Poppins',
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    height: 40.0,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: Colors.orange[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  ),
);
