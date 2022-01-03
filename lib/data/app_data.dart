import 'package:flutter/material.dart';

const String appName = 'Cadets Nearby';

const TextStyle textStyle = TextStyle(
  fontWeight: FontWeight.w300,
);

const TextStyle textStyleDark = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.white,
);

final ThemeData lightTheme = ThemeData(
  fontFamily: 'DMSans',
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  secondaryHeaderColor: Colors.orange,
  backgroundColor: Colors.orange[200],
  bottomAppBarColor: Colors.orange[100],
  textTheme: const TextTheme(
    bodyText1: textStyle,
    bodyText2: textStyle,
    subtitle1: textStyle,
    subtitle2: textStyle,
    headline1: textStyle,
    headline2: textStyle,
    headline3: textStyle,
    headline4: textStyle,
    headline5: textStyle,
    headline6: textStyle,
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
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.deepOrange,
  ),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'DMSans',
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  secondaryHeaderColor: Colors.orange,
  backgroundColor: Colors.grey[900],
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.black),
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  bottomAppBarColor: Colors.grey[800],
  textTheme: const TextTheme(
    bodyText1: textStyleDark,
    bodyText2: textStyleDark,
    subtitle1: textStyleDark,
    subtitle2: textStyleDark,
    headline1: textStyleDark,
    headline2: textStyleDark,
    headline3: textStyleDark,
    headline4: textStyleDark,
    headline5: textStyleDark,
    headline6: textStyleDark,
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
  'Select college',
  'MGCC',
  'JGCC',
  'FGCC',
  'SCC',
  'CCC',
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
  'Others',
  'Police Forces',
  'Student'
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
