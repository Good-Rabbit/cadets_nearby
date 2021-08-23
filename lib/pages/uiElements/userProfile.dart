import 'package:cadets_nearby/services/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.e,
  }) : super(key: key);

  final AppUser e;

  void launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    String emailAddress = 'mailto:' + e.email;
    String phoneNumber = 'tel:' + e.phone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                radius: 40.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: e.photoUrl == ''
                      ? Image.asset('assets/images/user.png')
                      : Image.network(
                          e.photoUrl,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(),
                  ),
                  if (e.premium) Text(''),
                  Text(
                    'Cadet No:',
                    style: TextStyle(),
                  ),
                  Text(
                    'College:',
                    style: TextStyle(),
                  ),
                  Text(
                    'Profession:',
                    style: TextStyle(),
                  ),
                  Text(
                    'At:',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.fullName,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (e.celeb)
                      Icon(
                        Icons.verified,
                        size: 15,
                        color: Colors.green,
                      ),
                    if (e.verified != 'yes')
                      Icon(
                        Icons.info_rounded,
                        size: 15,
                        color: Colors.redAccent,
                      ),
                  ],
                ),
                if (e.premium)
                  Text(
                    'Premium User',
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                Text(
                  e.cNumber.toString(),
                ),
                Text(
                  e.college + ' (' + e.intake.toString() + ') ',
                ),
                Text(
                  e.profession,
                ),
                Text(
                  e.workplace,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (e.fbUrl != '')
              ElevatedButton.icon(
                onPressed: () {
                  launchURL('https://fb.com/${e.fbUrl}');
                },
                icon: Icon(Icons.facebook),
                label: Text('Facebook'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                ),
              ),
            if (e.instaUrl != '' && e.fbUrl != '')
              SizedBox(
                width: 20,
              ),
            if (e.instaUrl != '')
              ElevatedButton.icon(
                onPressed: () {
                  launchURL('https://instagr.am/${e.instaUrl}');
                },
                icon: Icon(FontAwesomeIcons.instagram),
                label: Text('Instagram'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  launchURL(emailAddress);
                },
                icon: Icon(Icons.alternate_email),
                label: Text(e.email),
              ),
              if (!e.pPhone) Text('Phone number is private'),
              if (e.pPhone)
                TextButton.icon(
                  onPressed: () {
                    launchURL(phoneNumber);
                  },
                  icon: Icon(Icons.phone),
                  label: Text(e.phone),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
