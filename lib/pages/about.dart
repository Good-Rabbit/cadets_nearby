import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.info_outline_rounded,
                size: 100,
                color: Colors.red,
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: const Text(
                  'Cadets Nearby is a system by the cadets, for the cadets. With this, you can easily find cadets who are nearby. Making it very convenient for you to find and communicate with each other.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
