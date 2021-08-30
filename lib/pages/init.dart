import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1))
        .then((value) => Navigator.of(context).pushReplacementNamed('/home'));
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/icon.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
