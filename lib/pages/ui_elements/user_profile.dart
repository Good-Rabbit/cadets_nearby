import 'package:cadets_nearby/services/ad_service.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.e,
  }) : super(key: key);

  final AppUser e;

  @override
  Widget build(BuildContext context) {
    final String emailAddress = 'mailto:${e.email}';
    final String phoneNumber = 'tel:${e.phone}';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name:',
                  ),
                  if (e.premium) const Text(''),
                  const Text(
                    'Cadet No:',
                  ),
                  const Text(
                    'College:',
                  ),
                  const Text(
                    'Profession:',
                  ),
                  const Text(
                    'Designation:',
                  ),
                  const Text(
                    'Address:',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        e.fullName,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (e.celeb)
                        const Icon(
                          Icons.verified,
                          size: 15,
                          color: Colors.green,
                        ),
                      if (e.verified != 'yes')
                        const Icon(
                          Icons.info_rounded,
                          size: 15,
                          color: Colors.redAccent,
                        ),
                    ],
                  ),
                  if (e.premium)
                    const Text(
                      'Premium User',
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  Text(
                    e.cNumber.toString(),
                    maxLines: 1,
                  ),
                  Text(
                    '${e.college} (${e.intake}) ',
                    maxLines: 1,
                  ),
                  Text(
                    e.profession != '' ? e.profession : '-',
                    maxLines: 1,
                  ),
                  Text(
                    e.designation != '' ? e.designation : '-',
                    maxLines: 1,
                  ),
                  Text(
                    e.address,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (e.fbUrl != '')
              ElevatedButton.icon(
                onPressed: () {
                  if (context.watch<MainUser>().user!.premium ||
                      context.watch<Settings>().reward) {
                    launchURL('https://fb.com/${e.fbUrl}');
                  } else {
                    final bool ready = AdService.isRewardedAdReady;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                ready ? 'Watch ad?' : 'Sorry, no ad available'),
                            actions: [
                              if (ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    AdService.rewardedAd.show(
                                        onUserEarnedReward: (ad, item) {
                                      context.read<Settings>().reward = true;
                                      Future.delayed(
                                              const Duration(minutes: 30))
                                          .then((e) {
                                        context.read<Settings>().reward = false;
                                      });
                                      launchURL('https://fb.com/${e.fbUrl}');
                                    });
                                  },
                                  child: const Text('Watch ad'),
                                ),
                              if (ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              if (!ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                            ],
                          );
                        });
                  }
                },
                icon: const Icon(Icons.facebook),
                label: const Text('Facebook'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                ),
              ),
            if (e.instaUrl != '' && e.fbUrl != '')
              const SizedBox(
                width: 20,
              ),
            if (e.instaUrl != '')
              ElevatedButton.icon(
                onPressed: () {
                  if (context.watch<MainUser>().user!.premium ||
                      context.watch<Settings>().reward) {
                    launchURL('https://instagr.am/${e.instaUrl}');
                  } else {
                    final bool ready = AdService.isRewardedAdReady;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                ready ? 'Watch ad?' : 'Sorry, no ad available'),
                            actions: [
                              if (ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    AdService.rewardedAd.show(
                                        onUserEarnedReward: (ad, item) {
                                      context.read<Settings>().reward = true;
                                      Future.delayed(
                                              const Duration(minutes: 30))
                                          .then((e) {
                                        context.read<Settings>().reward = false;
                                      });
                                      launchURL(
                                          'https://instagr.am/${e.instaUrl}');
                                    });
                                  },
                                  child: const Text('Watch ad'),
                                ),
                              if (ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              if (!ready)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                            ],
                          );
                        });
                  }
                },
                icon: const Icon(FontAwesomeIcons.instagram),
                label: const Text('Instagram'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  launchURL(emailAddress);
                },
                icon: const Icon(Icons.alternate_email),
                label: Text(e.email),
              ),
              if (!e.pPhone) const Text('Phone number is private'),
              if (e.pPhone)
                TextButton.icon(
                  onPressed: () {
                    launchURL(phoneNumber);
                  },
                  icon: const Icon(Icons.phone),
                  label: Text(e.phone),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
