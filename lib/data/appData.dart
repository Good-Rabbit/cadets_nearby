import 'package:flutter/material.dart';

String appName = 'Cadets Nearby';

TextStyle textStyle = TextStyle(
      fontWeight: FontWeight.w300,
    );

ThemeData lightTheme = ThemeData(
  fontFamily: 'DMSans',
  primarySwatch: Colors.deepOrange,
  primaryColor: Colors.deepOrange,
  accentColor: Colors.orange,
  backgroundColor: Colors.orange[200],
  bottomAppBarColor: Colors.orange[100],
  textTheme: TextTheme(
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

  List<String> colleges = [
    'Pick your college*',
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

  List<String> professions = [
    'Defense Forces',
    'Doctor',
    'Engineer',
    'Government Service Holder',
    'Others',
    'Police Forces',
    'Student'
  ];

  List<String> districts = [
    'Bagerhat',
    'Bandarban',
    'Barguna',
    'Barisal',
    'Bhola',
    'Bogra',
    'Brahmanbaria',
    'Chandpur',
    'Chittagong',
    'Chuadanga',
    'Comilla',
    'Cox\'s Bazar',
    'Dhaka',
    'Dinajpur',
    'Faridpur',
    'Feni',
    'Gaibandha',
    'Gazipur',
    'Gopalganj',
    'Habiganj',
    'Jaipurhat',
    'Jamalpur',
    'Jessore',
    'Jhalakati',
    'Jhenaidah',
    'Khagrachari',
    'Khulna',
    'Kishoreganj',
    'Kurigram',
    'Kushtia',
    'Lakshmipur',
    'Lalmonirhat',
    'Madaripur',
    'Magura',
    'Manikganj',
    'Meherpur',
    'Moulvibazar',
    'Munshiganj',
    'Mymensingh',
    'Naogaon',
    'Narail',
    'Narayanganj',
    'Narsingdi',
    'Natore',
    'Nawabganj',
    'Netrakona',
    'Nilphamari',
    'Noakhali',
    'Pabna',
    'Panchagarh',
    'Parbattya Chattagram',
    'Patuakhali',
    'Pirojpur',
    'Rajbari',
    'Rajshahi',
    'Rangpur',
    'Satkhira',
    'Shariatpur',
    'Sherpur',
    'Sirajganj',
    'Sunamganj',
    'Sylhet',
    'Tangail',
    'Thakurgaon',
  ];
