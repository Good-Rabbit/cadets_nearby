import 'package:cadets_nearby/pages/uiElements/verificationSteps.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Icon(
              Icons.warning_rounded,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            VerificationSteps(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: Text('Cancel'),
              icon: Icon(
                Icons.arrow_left_rounded,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
