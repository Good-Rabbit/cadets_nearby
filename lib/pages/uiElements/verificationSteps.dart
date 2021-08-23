import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerificationSteps extends StatefulWidget {
  VerificationSteps({Key? key}) : super(key: key);

  @override
  _VerificationStepsState createState() => _VerificationStepsState();
}

class _VerificationStepsState extends State<VerificationSteps> {
  bool emailV = false;
  bool cadetV = false;
  @override
  Widget build(BuildContext context) {
    emailV = HomeSetterPage.auth.currentUser!.emailVerified;
    cadetV = HomeSetterPage.mainUser!.verified == 'yes';
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Get Verified',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/verifyemail');
            },
            child: Row(
              children: [
                Icon(
                  emailV ? FontAwesomeIcons.check : FontAwesomeIcons.times,
                  color: emailV ? Colors.green : Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: Text('Verify e-mail')),
              ],
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/verifycadet');
            },
            child: Row(
              children: [
                Icon(
                  cadetV ? FontAwesomeIcons.check : FontAwesomeIcons.times,
                  color: cadetV ? Colors.green : Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'Verify that you are a cadet(ex/present)' +
                        (HomeSetterPage.mainUser!.verified == 'waiting'
                            ? ' - Pending Verification'
                            : ''),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
