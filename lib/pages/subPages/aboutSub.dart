import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSubPage extends StatefulWidget {
  AboutSubPage({Key? key}) : super(key: key);

  @override
  _AboutSubPageState createState() => _AboutSubPageState();
}

class _AboutSubPageState extends State<AboutSubPage>
    with AutomaticKeepAliveClientMixin {
  void launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Icon(
              Icons.info_outline_rounded,
              size: 100,
              color: Colors.red,
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                'Cadets Nearby is a system by the cadets, for the cadets. With this, you can easily find cadets who are nearby. Making it very convenient for you to find and communicate with each other.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                'Want to ckeck out what we are doing behind the scene?',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Visit our ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      launchURL('https://github.com/Saim20/cadets_nearby');
                    },
                    icon: Icon(
                      FontAwesomeIcons.github,
                    ),
                    label: Text('Github page'),
                  ),
                ],
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
