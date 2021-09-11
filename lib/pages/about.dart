import 'package:cadets_nearby/main.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.info_rounded),
            SizedBox(
              width: 10,
            ),
            Text(
              'About Us',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
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
    );
  }
}
