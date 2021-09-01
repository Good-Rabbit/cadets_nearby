import 'dart:ui';

import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutSubPage extends StatefulWidget {
  const AboutSubPage({Key? key}) : super(key: key);

  @override
  _AboutSubPageState createState() => _AboutSubPageState();
}

class _AboutSubPageState extends State<AboutSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
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
            Container(
              margin: const EdgeInsets.all(15),
              child: const Text(
                'Want to ckeck out what we are doing behind the scene?',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Visit our ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      launchURL('https://github.com/Saim20/cadets_nearby');
                    },
                    icon: const Icon(
                      FontAwesomeIcons.github,
                    ),
                    label: const Text('Github page'),
                  ),
                ],
              ),
            ),
            const Text(
              'Devs',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Saim Ul Islam',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Text(
              'KM Mynur',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Project Manager',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Muaz Fahim Faruki',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              child: const Text(
                'Service by',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              'GoldenFleece',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
