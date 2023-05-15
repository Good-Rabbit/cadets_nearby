import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class VerificationSteps extends StatefulWidget {
  const VerificationSteps({Key? key}) : super(key: key);

  @override
  VerificationStepsState createState() => VerificationStepsState();
}

class VerificationStepsState extends State<VerificationSteps> {
  bool emailV = false;
  bool cadetV = false;
  bool emailFirst = false;

  @override
  Widget build(BuildContext context) {
    emailV = HomeSetterPage.auth.currentUser!.emailVerified;
    cadetV = context.read<MainUser>().user!.verified == 'yes';
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
          FilledButton.icon(
            onPressed: () {},
            icon: Icon(
              emailV ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
            ),
            label: const Expanded(child: Text('E-mail verification')),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green[800]),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () {
              if (emailV) {
                if (context.read<MainUser>().user!.verified != 'waiting') {
                  Navigator.of(context).pushNamed('/verifycadet');
                }
              } else {
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
              cadetV ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
              // color: cadetV ? Colors.green : Colors.red,
            ),
            label: Expanded(
              child: Text(
                'Cadet verification${context.read<MainUser>().user!.verified == 'waiting' ? ' - Waiting' : ''}',
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
          FilledButton.icon(
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
