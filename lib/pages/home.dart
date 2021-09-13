import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cadets_nearby/pages/sub_pages/contact_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/help_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/home_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_sub.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<void> onLogin() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      if (event["latitude"] != null) {
        zoneCount = 0;
        zoneOnce = false;
        service.setNotificationInfo(
          title: "Starting zone detection",
          content: "",
        );

        if (zoneStreamSubscription != null) {
          zoneStreamSubscription!.cancel();
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
                    channel.description,
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

        final double latitude = event['latitude'];
        // final double longitude = event['longitude'];

        zoneStream = FirebaseFirestore.instance
            .collection('users')
            .where('lat',
                isLessThan: latitude + 0.046, isGreaterThan: latitude - 0.046)
            .where('sector', whereIn: [
          event["sector"] - 1,
          event["sector"],
          event["sector"] + 1,
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
                  channel.description,
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

        service.setForegroundMode(false);
      }
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
      if (zoneStreamSubscription != null) {
        zoneStreamSubscription!.cancel();
        zoneStreamSubscription = null;
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
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Future<void> startService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    if (prefs.getBool('zoneDetection') ?? true) {
      FlutterBackgroundService.initialize(
        onLogin,
        foreground: false,
      );
    }
  }

  @override
  void initState() {
    startService();
    super.initState();
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
          backgroundColor: Theme.of(context).backgroundColor,
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: const [
              HomeSubPage(),
              OfferSubPage(),
              AboutSubPage(),
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
                icon: const Icon(Icons.backpack),
                title: const Text('Offers'),
                textAlign: TextAlign.center,
                activeColor: Colors.purpleAccent,
                inactiveColor: Theme.of(context).secondaryHeaderColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.support),
                title: const Text('Help'),
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
