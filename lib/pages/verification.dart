import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

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
                height: 30,
              ),
              Icon(
                Icons.warning,
                size: 100,
                color: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Submit a document bearing proof that you are a present or an ex cadet',
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Select photo'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Container(
                      width: 500,
                      child: AlertDialog(
                        title: Text('Are you sure'),
                        content: Text(
                          'Your account will be marked as unverified until you upload a valid document of proof',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text('Later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
