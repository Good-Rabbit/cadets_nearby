import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool disabled = false;
  bool once = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Icon(
                Icons.alternate_email_rounded,
                size: 100,
                color: Colors.red,
              ),
              Text(
                'E-mail verification',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
                child: Text(
                  'A link will be sent by e-mail to this address. Click on the link to verify that this e-mail really belongs to you.',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (!disabled) {
                    if (!once) {
                      once = true;
                    }
                    HomeSetterPage.auth.currentUser!
                        .sendEmailVerification()
                        .then((value) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('E-mail sent')));
                      setState(() {
                        disabled = true;
                      });
                      Future.delayed(Duration(minutes: 1)).then((value) {
                        setState(() {
                          disabled = false;
                        });
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Wait 1 minutes before trying again')));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      disabled ? Colors.grey[800] : null),
                ),
                icon: Icon(Icons.email_rounded),
                label: Text(
                  once ? 'Resend e-mail' : 'Verify e-mail',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_left_rounded,
                ),
                label: Text('Return'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
