import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cadets_nearby/pages/sub_pages/contact_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/feed_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/home_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_sub.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? Background Service
// Future<void> onLogin() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final service = FlutterBackgroundService();
//   service.setForegroundMode(false);

//   service.onDataReceived.listen((event) async {
//     if (event!['action'] == 'setAsForeground') {
//       service.setForegroundMode(true);
//     }

//     if (event['action'] == 'setAsBackground') {
//       service.setForegroundMode(false);
//     }

//     if (event['action'] == 'stopService') {
//       service.stopBackgroundService();
//     }
//   });
// }
//? Background Service

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  RealHomeState createState() => RealHomeState();
}

class RealHomeState extends State<RealHome> {
  final pages = const [
    HomeSubPage(),
    OfferSubPage(),
    FeedSubPage(),
    ContactSubPage(),
  ];

  int selectedIndex = 0;
  final pageController = PageController(initialPage: 0);

  void setSelectedIndex(int index) {
    if (index == 1) {
      if (context.read<MainUser>().user!.verified != 'yes') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Get verified first'),
                content: const Text(
                    'You have to get verified first to be able to use this'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok.')),
                ],
              );
            });
        return;
      }
    }
    context.read<LocationStatus>().checkPermissions();
    selectedIndex = index;
    pageController.jumpToPage(
      index,
      // duration: const Duration(milliseconds: 300), curve: Curves.decelerate
    );
  }

  // Future<void> startService() async {
  //   FlutterBackgroundService.initialize(
  //     onLogin,
  //     foreground: false,
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 1)).then((value) {
    //   startService();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setSelectedIndex(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              if (index == 1) {
                if (context.read<MainUser>().user!.verified != 'yes') {
                  pageController.animateToPage(selectedIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Get verified first'),
                          content: const Text(
                              'You have to get verified first to be able to use this'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok.')),
                          ],
                        );
                      });
                  return;
                }
              }
              setState(() {
                selectedIndex = index;
              });
            },
            children: pages,
          ),
          bottomNavigationBar: BottomNavyBar(
            itemCornerRadius: 10,
            selectedIndex: selectedIndex,
            showElevation: false,
            backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            onItemSelected: (index) => setState(() {
              setSelectedIndex(index);
            }),
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home_rounded),
                title: const Text('Home'),
                textAlign: TextAlign.center,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.backpack_rounded),
                title: const Text('Offers'),
                textAlign: TextAlign.center,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.feed_rounded),
                title: const Text('Feed'),
                textAlign: TextAlign.center,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.contacts_rounded),
                title: const Text('Contacts'),
                textAlign: TextAlign.center,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          )),
    );
  }
}
