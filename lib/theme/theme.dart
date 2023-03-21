import 'package:flutter/material.dart';

const TextStyle textStyle = TextStyle(
  fontWeight: FontWeight.w300,
);

const TextStyle textStyleDark = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.white,
);

const BottomAppBarTheme lightBottomAppBarTheme =
    BottomAppBarTheme(color: Colors.white);

const BottomAppBarTheme darkBottomAppBarTheme =
    BottomAppBarTheme(color: Color.fromARGB(255, 25, 25, 25));

TextTheme textTheme = const TextTheme(
  bodyLarge: textStyle,
  bodyMedium: textStyle,
  titleLarge: textStyle,
  titleMedium: textStyle,
  titleSmall: textStyle,
  displayLarge: textStyle,
  displayMedium: textStyle,
  displaySmall: textStyle,
  headlineMedium: textStyle,
  headlineSmall: textStyle,
);

const MaterialColor primarySwatchColor = Colors.orange;
const MaterialColor secondarySwatchColor = Colors.orange;
const MaterialColor popupColor = Colors.orange;

const double cardElevation = 0.001;
const double buttonElevation = 0;

PopupMenuThemeData popupMenuThemeData = PopupMenuThemeData(
  color: popupColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

const AppBarTheme appBarTheme = AppBarTheme(
  foregroundColor: primarySwatchColor,
  iconTheme: IconThemeData(color: primarySwatchColor),
  actionsIconTheme: IconThemeData(color: primarySwatchColor),
  color: primarySwatchColor,
);

const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.orangeAccent,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Colors.white,
    onBackground: Color.fromARGB(255, 255, 225, 180),
    surface: Colors.transparent,
    onSurface: Colors.transparent);

const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.orangeAccent,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Color.fromARGB(255, 25, 25, 25),
    onBackground: Color.fromARGB(255, 45, 45, 45),
    surface: Colors.transparent,
    onSurface: Colors.transparent);

final ThemeData lightTheme = ThemeData(
  appBarTheme: appBarTheme,
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  fontFamily: 'DMSans',
  colorScheme: lightScheme,
  popupMenuTheme: popupMenuThemeData,
  primarySwatch: primarySwatchColor,
  primaryColor: primarySwatchColor,
  secondaryHeaderColor: secondarySwatchColor,
  bottomAppBarTheme: lightBottomAppBarTheme,
  textTheme: textTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontFamily: 'DMSans',
          color: Colors.white,
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(70, 40)),
      elevation: MaterialStateProperty.all(buttonElevation),
    ),
  ),
  cardTheme: CardTheme(
    elevation: cardElevation,
    color: const Color.fromARGB(220, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  chipTheme: ChipThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.orange[50]!,
    disabledColor: Colors.orange[100]!,
    labelStyle: const TextStyle(color: Colors.black),
    padding: EdgeInsets.zero,
    secondaryLabelStyle: TextStyle(color: Colors.grey[800]!),
    secondarySelectedColor: Colors.orange[100]!,
    selectedColor: Colors.orange[100]!,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color.fromARGB(220, 255, 255, 255),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: primarySwatchColor,
  ),
);

final ThemeData darkTheme = ThemeData(
  appBarTheme: appBarTheme,
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  colorScheme: darkScheme,
  fontFamily: 'DMSans',
  popupMenuTheme: popupMenuThemeData,
  primarySwatch: primarySwatchColor,
  primaryColor: primarySwatchColor,
  disabledColor: Colors.grey[800],
  secondaryHeaderColor: secondarySwatchColor,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.black),
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  bottomAppBarTheme: darkBottomAppBarTheme,
  textTheme: const TextTheme(
    bodyLarge: textStyleDark,
    bodyMedium: textStyleDark,
    titleLarge: textStyleDark,
    titleMedium: textStyleDark,
    titleSmall: textStyleDark,
    displayLarge: textStyleDark,
    displayMedium: textStyleDark,
    displaySmall: textStyleDark,
    headlineMedium: textStyleDark,
    headlineSmall: textStyleDark,
  ),
  chipTheme: ChipThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.grey[800]!,
    disabledColor: Colors.grey[800]!,
    labelStyle: const TextStyle(color: Colors.white),
    padding: EdgeInsets.zero,
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    secondarySelectedColor: Colors.grey[800]!,
    selectedColor: Colors.grey[800]!,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontFamily: 'DMSans',
          color: Colors.white,
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return primarySwatchColor;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey[800]!;
          }
          return primarySwatchColor; // Use the component's default.
        },
      ),
      minimumSize: MaterialStateProperty.all(const Size(70, 40)),
      elevation: MaterialStateProperty.all(buttonElevation),
    ),
  ),
  cardTheme: CardTheme(
    elevation: cardElevation,
    color: const Color.fromARGB(255, 45, 45, 45),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  dialogTheme: DialogTheme(backgroundColor: Colors.grey[850]),
  iconTheme: const IconThemeData(color: Colors.white),
  primaryTextTheme: const TextTheme(
    bodyLarge: textStyleDark,
    bodyMedium: textStyleDark,
    labelLarge: textStyleDark,
    titleMedium: textStyleDark,
    titleSmall: textStyleDark,
    displayLarge: textStyleDark,
    displayMedium: textStyleDark,
    displaySmall: textStyleDark,
    headlineMedium: textStyleDark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[700],
    hintStyle: TextStyle(color: Colors.grey[300]),
    iconColor: Colors.grey[200],
    labelStyle: const TextStyle(color: Colors.white),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: primarySwatchColor,
  ),
);
