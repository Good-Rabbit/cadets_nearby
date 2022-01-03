import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cadets_nearby/pages/sub_pages/contact_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/home_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/support_sub.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<void> onLogin() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('zoneDetection')==null){
    prefs.setBool('zoneDetection', true);
  }

  final service = FlutterBackgroundService();
  // * Send to background
  service.setForegroundMode(false);
  Stream? zoneStream;
  StreamSubscription<dynamic>? zoneStreamSubscription;

  Stream? supportStream;
  StreamSubscription<dynamic>? supportStreamSubscription;

  int zoneCount = 0;
  int supportCount = 0;

  bool zoneOnce = false;
  bool supportOnce = false;

  service.onDataReceived.listen((event) async {
    if (event!['action'] == 'setAsForeground') {
      if (event['latitude'] != null) {
        zoneCount = 0;
        zoneOnce = false;
        await prefs.reload();
        if (prefs.getBool('zoneDetection')!) {
          service.setNotificationInfo(
            title: 'Starting zone detection',
            content: '',
          );
          if (zoneStreamSubscription != null) {
            zoneStreamSubscription!.cancel();
          }
          final double latitude = event['latitude'];
          // final double longitude = event['longitude'];

          zoneStream = FirebaseFirestore.instance
              .collection('users')
              .where('lat',
                  isLessThan: latitude + 0.046, isGreaterThan: latitude - 0.046)
              .where('sector', whereIn: [
            event['sector'] - 1,
            event['sector'],
            event['sector'] + 1,
          ]).snapshots();

          zoneStreamSubscription = zoneStream!.listen((value) {
            final QuerySnapshot<Map<String, dynamic>> snap =
                value as QuerySnapshot<Map<String, dynamic>>;
            if (!zoneOnce) {
              zoneCount = snap.docs.length;
              zoneOnce = true;
            } else if (zoneCount < snap.docs.length) {
              zoneCount = snap.docs.length;
              LocalNotificationService.notificationsPlugin.show(
                DateTime.now().hashCode,
                'Someone has entered your zone!',
                'Check who it is and fix your rendezvous!',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    importance: Importance.max,
                    icon: '@mipmap/ic_launcher',
                    priority: Priority.high,
                  ),
                ),
              );
            } else {
              zoneCount = snap.docs.length;
            }
          });
        }

        if (supportStreamSubscription == null) {
          supportStream = FirebaseFirestore.instance
              .collection('support')
              .where('id', isNotEqualTo: event['id'])
              .where(
            'status',
            whereIn: ['approved', 'emergency'],
          ).snapshots();
          supportStreamSubscription = supportStream!.listen((value) {
            final QuerySnapshot<Map<String, dynamic>> snap = value;
            if (!supportOnce) {
              supportCount = snap.docs.length;
              supportOnce = true;
            } else if (supportCount < snap.docs.length) {
              supportCount = snap.docs.length;
              LocalNotificationService.notificationsPlugin.show(
                DateTime.now().hashCode,
                'Someone needs your support',
                'There is a new support request. See if you can help',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    importance: Importance.max,
                    icon: '@mipmap/ic_launcher',
                    priority: Priority.high,
                  ),
                ),
              );
            } else {
              supportCount = snap.docs.length;
            }
          });
        }

        service.setForegroundMode(false);
      }
      return;
    }

    if (event['action'] == 'setAsBackground') {
      service.setForegroundMode(false);
    }

    if (event['action'] == 'stopService') {
      service.stopBackgroundService();
      if (zoneStreamSubscription != null) {
        zoneStreamSubscription!.cancel();
        zoneStreamSubscription = null;
      }
      if (supportStreamSubscription != null) {
        supportStreamSubscription!.cancel();
        supportStreamSubscription = null;
      }
    }
  });
}

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  _RealHomeState createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
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

  Future<void> startService() async {
    FlutterBackgroundService.initialize(
      onLogin,
      foreground: false,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      startService();
    });
  }

  @override
  Widget build(BuildContext context) {
    //! Load Video Ads
    // if (!(context.read<MainUser>().user!.premium ||
    //     context.read<s_provider.Settings>().reward)) {
    //   if (!AdService.isRewardedAdReady) {
    //     AdService.loadRewardedAd();
    //   }
    // }
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setSelectedIndex(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
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
            children: const [
              HomeSubPage(),
              OfferSubPage(),
              SupportSubPage(),
              ContactSubPage(),
            ],
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: selectedIndex,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            onItemSelected: (index) => setState(() {
              setSelectedIndex(index);
            }),
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home_rounded),
                title: const Text('Home'),
                textAlign: TextAlign.center,
                activeColor: Colors.redAccent,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.backpack_rounded),
                title: const Text('Offers'),
                textAlign: TextAlign.center,
                activeColor: Colors.purpleAccent,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.support_rounded),
                title: const Text('Support'),
                textAlign: TextAlign.center,
                activeColor: Colors.teal,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.contacts_rounded),
                title: const Text('Contacts'),
                textAlign: TextAlign.center,
                activeColor: Colors.brown,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          )),
    );
  }
}
