import 'package:flutter/material.dart';

const String appName = 'Cadets Nearby';

const TextStyle textStyle = TextStyle(
  fontWeight: FontWeight.w300,
);

const TextStyle textStyleDark = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.white,
);

final ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.deepOrange,
    onPrimary: Colors.deepOrangeAccent,
    secondary: Colors.orange,
    onSecondary: Colors.orangeAccent,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Colors.orange.shade200,
    onBackground: Colors.orange.shade100,
    surface: Colors.transparent,
    onSurface: Colors.transparent);
  
final BottomAppBarTheme lightAppBarTheme = BottomAppBarTheme(color: Colors.orange.shade100);

final ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.deepOrange,
    onPrimary: Colors.deepOrangeAccent,
    secondary: Colors.orange,
    onSecondary: Colors.orangeAccent,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Colors.grey.shade900,
    onBackground: Colors.grey.shade800,
    surface: Colors.transparent,
    onSurface: Colors.transparent);

final BottomAppBarTheme darkAppBarTheme = BottomAppBarTheme(color: Colors.grey.shade800);
  
const MaterialColor primarySwatchColor = Colors.deepOrange;
const MaterialColor secondarySwatchColor = Colors.orange;
const MaterialColor popupColor = Colors.orange;

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

final ThemeData lightTheme = ThemeData(
  fontFamily: 'DMSans',
  colorScheme: lightScheme,
  popupMenuTheme: PopupMenuThemeData(
    color: popupColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  primarySwatch: primarySwatchColor,
  primaryColor: primarySwatchColor,
  secondaryHeaderColor: secondarySwatchColor,
  bottomAppBarTheme: lightAppBarTheme,
  textTheme: textTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontFamily: 'DMSans',
          color: Colors.white,
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(70, 40)),
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
  chipTheme: ChipThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.orange[100]!,
    disabledColor: Colors.orange[100]!,
    labelStyle: TextStyle(color: Colors.grey[800]!),
    padding: EdgeInsets.zero,
    secondaryLabelStyle: TextStyle(color: Colors.grey[800]!),
    secondarySelectedColor: Colors.orange[100]!,
    selectedColor: Colors.orange[100]!,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.deepOrange,
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: darkScheme,
  fontFamily: 'DMSans',
  popupMenuTheme: PopupMenuThemeData(
    color: popupColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  primarySwatch: primarySwatchColor,
  primaryColor: primarySwatchColor,
  disabledColor: Colors.grey[400],
  secondaryHeaderColor: Colors.orange,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.black),
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  bottomAppBarTheme: darkAppBarTheme,
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
          borderRadius: BorderRadius.circular(30.0),
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
            return Colors.deepOrange;
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }
          return Colors.deepOrange; // Use the component's default.
        },
      ),
      minimumSize: MaterialStateProperty.all(const Size(70, 40)),
      elevation: MaterialStateProperty.all(0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: Colors.grey[800],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
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
      borderRadius: BorderRadius.circular(40.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.deepOrange,
  ),
);

const List<String> colleges = [
  'Pick your college*',
  'MGCC',
  'JGCC',
  'FGCC',
  'SCC',
  'CCC',
  'PCC',
  'RCC',
  'BCC',
  'JCC',
  'FCC',
  'CCR',
  'MCC',
];

const List<String> filterColleges = [
  'All Colleges',
  'MGCC',
  'JGCC',
  'FGCC',
  'SCC',
  'CCC',
  'BCC',
  'PCC',
  'RCC',
  'JCC',
  'FCC',
  'CCR',
  'MCC',
];

const List<String> professions = [
  'Defense Forces',
  'Doctor',
  'Engineer',
  'Government Service Holder',
  'Other',
  'Police Forces',
  'Student'
];

const List<String> nearbyRange = [
  '500 m',
  '1000 m',
  '2000 m',
  '4000 m',
  '6000 m',
  '8000 m - Expensive!',
];

// const List<String> districts = [
//   'Bagerhat',
//   'Bandarban',
//   'Barguna',
//   'Barisal',
//   'Bhola',
//   'Bogra',
//   'Brahmanbaria',
//   'Chandpur',
//   'Chittagong',
//   'Chuadanga',
//   'Comilla',
//   "Cox's Bazar",
//   'Dhaka',
//   'Dinajpur',
//   'Faridpur',
//   'Feni',
//   'Gaibandha',
//   'Gazipur',
//   'Gopalganj',
//   'Habiganj',
//   'Jaipurhat',
//   'Jamalpur',
//   'Jessore',
//   'Jhalakati',
//   'Jhenaidah',
//   'Khagrachari',
//   'Khulna',
//   'Kishoreganj',
//   'Kurigram',
//   'Kushtia',
//   'Lakshmipur',
//   'Lalmonirhat',
//   'Madaripur',
//   'Magura',
//   'Manikganj',
//   'Meherpur',
//   'Moulvibazar',
//   'Munshiganj',
//   'Mymensingh',
//   'Naogaon',
//   'Narail',
//   'Narayanganj',
//   'Narsingdi',
//   'Natore',
//   'Nawabganj',
//   'Netrakona',
//   'Nilphamari',
//   'Noakhali',
//   'Pabna',
//   'Panchagarh',
//   'Parbattya Chattagram',
//   'Patuakhali',
//   'Pirojpur',
//   'Rajbari',
//   'Rajshahi',
//   'Rangpur',
//   'Satkhira',
//   'Shariatpur',
//   'Sherpur',
//   'Sirajganj',
//   'Sunamganj',
//   'Sylhet',
//   'Tangail',
//   'Thakurgaon',
// ];
