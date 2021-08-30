import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSubPage extends StatefulWidget {
  ContactSubPage({Key? key}) : super(key: key);

  @override
  _ContactSubPageState createState() => _ContactSubPageState();
}

class _ContactSubPageState extends State<ContactSubPage>
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
              height: 30,
            ),
            Text(
              'Contacts',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
