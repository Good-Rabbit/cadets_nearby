import 'package:cadets_nearby/services/ad_service.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cadets_nearby/data/user.dart';
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
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Name:',
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              e.fullName,
                              maxLines: 2,
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
                      ),
                    ],
                  ),
                  // if (e.premium) const Text(''),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Cadet No:',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.cNumber.toString(),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'College:',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${e.college} (${e.intake}) ',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Profession:',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.profession != '' ? e.profession : '-',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Designation:',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.designation != '' ? e.designation : '-',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Address:',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.address,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text(
            //             e.fullName,
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           if (e.celeb)
            //             const Icon(
            //               Icons.verified,
            //               size: 15,
            //               color: Colors.green,
            //             ),
            //           if (e.verified != 'yes')
            //             const Icon(
            //               Icons.info_rounded,
            //               size: 15,
            //               color: Colors.redAccent,
            //             ),
            //         ],
            //       ),
            //       Text(
            //         e.cNumber.toString(),
            //         maxLines: 1,
            //       ),
            //       Text(
            //         '${e.college} (${e.intake}) ',
            //         maxLines: 1,
            //       ),
            //       Text(
            //         e.profession != '' ? e.profession : '-',
            //         maxLines: 1,
            //       ),
            //       Text(
            //         e.designation != '' ? e.designation : '-',
            //         maxLines: 1,
            //       ),
            //       Text(
            //         e.address,
            //         maxLines: 3,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (e.fbUrl != '')
              SizedBox(
                width: 140,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // launchWithCheck('https://fb.com/${e.fbUrl}', context);
                    launchURL('https://fb.com/${e.fbUrl}');
                  },
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Facebook',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue[600]!.withAlpha(70)),
                  ),
                ),
              ),
            if (e.instaUrl != '' && e.fbUrl != '')
              const SizedBox(
                width: 10,
              ),
            if (e.instaUrl != '')
              SizedBox(
                width: 140,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // launchWithCheck(
                    // 'https://instagr.am/${e.instaUrl}', context);
                    launchURL('https://instagr.am/${e.instaUrl}');
                  },
                  icon: const Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Instagram',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.withAlpha(70)),
                  ),
                ),
              ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (e.pPhone)
                SizedBox(
                  width: 130,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // launchWithCheck(phoneNumber, context);
                      launchURL(phoneNumber);
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                    label: const Text(
                      'Phone',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.withAlpha(70)),
                    ),
                  ),
                ),
              if (e.pPhone)
                const SizedBox(
                  width: 10,
                ),
              SizedBox(
                width: 130,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // launchWithCheck(emailAddress, context);
                    launchURL(emailAddress);
                  },
                  icon: const Icon(
                    Icons.alternate_email,
                    color: Colors.purple,
                  ),
                  label: const Text(
                    'E-mail',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.purple.withAlpha(70)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void launchWithCheck(String url, BuildContext context) async {
    if (context.read<MainUser>().user!.premium ||
        context.read<Settings>().reward) {
      launchURL(url);
    } else {
      final bool ready = AdService.isRewardedAdReady;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(ready ? 'Watch ad?' : 'Sorry, no ad available'),
              actions: [
                if (ready)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      AdService.rewardedAd.show(
                          onUserEarnedReward: (ad, item) async {
                        onReward(url, context);
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
  }

  onReward(url, context) {
    Future.delayed(const Duration(seconds: 3)).then((e) {
      launchURL(url);
      context.read<Settings>().reward(true);
      Future.delayed(const Duration(minutes: 10)).then((e) {
        context.read<Settings>().reward(false);
      });
    });
  }
}
