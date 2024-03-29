import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1))
        .then((value) => Navigator.of(context).pushReplacementNamed('/home'));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
