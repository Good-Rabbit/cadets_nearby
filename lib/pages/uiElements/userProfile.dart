import 'package:cadets_nearby/services/user.dart';
import 'package:flutter/material.dart';
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
    String phoneNumber = 'tel:' + (e.phone ?? '');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            radius: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: e.photoUrl! == ''
                  ? Image.asset('assets/images/user.png')
                  : Image.network(
                      e.photoUrl!,
                    ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              e.fullName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
            if (!e.verified)
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
        Container(
          child: Text(
            e.cNumber.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: Text(
            e.college + ' (' + e.intake.toString() + ') ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.message),
          label: Text('Message - TODO'),
        ),
        TextButton.icon(
          onPressed: () {
            launchURL(emailAddress);
          },
          icon: Icon(Icons.alternate_email),
          label: Text(e.email),
        ),
        if (!e.pPhone || e.phone == null) Text('Phone number is private'),
        if (e.pPhone && e.phone != null)
          TextButton.icon(
            onPressed: () {
              launchURL(phoneNumber);
            },
            icon: Icon(Icons.phone),
            label: Text(e.phone!),
          ),
      ],
    );
  }
}
