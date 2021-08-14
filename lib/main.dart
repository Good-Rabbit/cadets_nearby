import 'package:cadets_nearby/pages/uiElements/userMessage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cadets_nearby/data/appData.dart';
import 'package:cadets_nearby/pages/cancel.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/pages/init.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/reset.dart';
import 'package:cadets_nearby/pages/signup.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cadets_nearby',
      theme: lightTheme,
      routes: {
        '/': (context) => _initialized ? HomeSetterPage() : InitPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupMainPage(),
        '/reset': (context) => ResetPage(),
        '/cancel': (context) => CancelVerificationPage(),
        '/message': (context) => UserMessagePage(),
      },
    );
  }
}
