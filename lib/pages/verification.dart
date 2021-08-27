import 'package:cadets_nearby/pages/uiElements/verificationSteps.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          VerificationSteps(),
        ],
      )),
    );
  }
}
