import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
              FontAwesomeIcons.cookieBite,
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
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                  child: const Text(
                    'This project is funded by',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(17),
                  child: Text(
                    'EX-CADETS',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: const Text(
                'Like our facebook page to stay up to date with the latest info',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                launchURL(context.read<Data>().cnLink ?? '');
              },
              icon: const Icon(Icons.facebook_rounded),
              label: const Text('Cadets Nearby'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                launchURL('mailto:info.cadetsnearby@gmail.com');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green[600]),
              ),
              icon: const Icon(Icons.alternate_email_rounded),
              label: const Text('Contact Us'),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Text(
                'Developed and maintained by',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                launchURL(context.read<Data>().grLink ?? '');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink[800]),
              ),
              icon: const Icon(Icons.facebook_rounded),
              label: const Text('Good Rabbit'),
            ),
          ],
        ),
      ),
    );
  }
}
