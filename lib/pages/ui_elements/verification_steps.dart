import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerificationSteps extends StatefulWidget {
  const VerificationSteps({Key? key}) : super(key: key);

  @override
  _VerificationStepsState createState() => _VerificationStepsState();
}

class _VerificationStepsState extends State<VerificationSteps> {
  bool emailV = false;
  bool cadetV = false;
  bool emailFirst = false;
  bool emailAlready = false;

  @override
  Widget build(BuildContext context) {
    emailV = HomeSetterPage.auth.currentUser!.emailVerified;
    cadetV = HomeSetterPage.mainUser!.verified == 'yes';
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const Hero(
            tag: 'warningHero',
            child: Icon(
              Icons.warning_rounded,
              size: 100,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Get Verified',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                emailAlready = true;
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  setState(() {
                    emailAlready = false;
                  });
                });
              });
            },
            icon: Icon(
              emailV ? FontAwesomeIcons.check : FontAwesomeIcons.times,
            ),
            label: const Expanded(child: Text('E-mail verification')),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
            ),
          ),
          if (emailAlready)
            const Text(
              'E-mail already verified',
              style: TextStyle(color: Colors.green),
            ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              if (emailV){
                Navigator.of(context).pushNamed('/verifycadet');

              }
              else {
                setState(() {
                  emailFirst = true;
                  Future.delayed(const Duration(seconds: 2)).then((value) {
                    setState(() {
                      emailFirst = false;
                    });
                  });
                });
              }
            },
            icon: Icon(
              cadetV ? FontAwesomeIcons.check : FontAwesomeIcons.times,
              // color: cadetV ? Colors.green : Colors.red,
            ),
            label: Expanded(
              child: Text(
                'Cadet verification${HomeSetterPage.mainUser!.verified == 'waiting'
                        ? ' - Waiting'
                        : ''}',
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
            ),
          ),
          if (emailFirst)
            const Text(
              'Please verify your e-mail first',
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: const Text('Cancel'),
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
