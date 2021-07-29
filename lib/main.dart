import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readiew/data/appData.dart';
import 'package:readiew/pages/homeSetter.dart';
import 'package:readiew/pages/init.dart';
import 'package:readiew/pages/login.dart';
import 'package:readiew/pages/phone.dart';
import 'package:readiew/pages/signupMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
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
      title: 'Readiew',
      theme: lightTheme,
      routes: {
        '/': (context) => _initialized ? HomeSetterPage() : InitPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupMainPage(),
        '/phoneSetup' : (context) => PhonePage(),
      },
    );
  }
}
