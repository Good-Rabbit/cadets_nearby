import 'package:flutter/material.dart';

String appName = 'Cadets Nearby';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  accentColor: Colors.orange,
  backgroundColor: Colors.orange[200],
  bottomAppBarColor: Colors.orange[100],
  textTheme: Typography.blackHelsinki,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
      elevation: MaterialStateProperty.all(0),
    ),
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
