import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool disabled = false;
  bool exit = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!exit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
            ),
          );
          exit = true;
          Future.delayed(const Duration(seconds: 2)).then((value) {
            exit = false;
          });
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.alternate_email_rounded,
                  size: 100,
                  color: Colors.red,
                ),
                const Text(
                  'E-mail verification',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 30),
                  child: Text(
                    'A link has been sent to you by e-mail to this address. Click on the link to verify that this e-mail really belongs to you.',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!disabled) {
                      HomeSetterPage.auth.currentUser!
                          .sendEmailVerification()
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('E-mail sent')));
                        setState(() {
                          disabled = true;
                        });
                        Future.delayed(const Duration(minutes: 1)).then((value) {
                          setState(() {
                            disabled = false;
                          });
                        });
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Wait 1 minutes before trying again')));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        disabled ? Colors.grey[800] : null),
                  ),
                  icon: const Icon(Icons.email_rounded),
                  label: const Text(
                    'Resend e-mail',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.signOut();
                    HomeSetterPage.auth.signOut();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.login,
                  ),
                  label: const Text('Verification complete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
