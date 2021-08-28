import 'package:cadets_nearby/pages/completeAccountPage.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class HomeSetterPage extends StatefulWidget {
  HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static AppUser? mainUser;
  static setMainUser(User? user) async {
    var u = await HomeSetterPage.store.collection('users').doc(user!.uid).get();
    HomeSetterPage.mainUser = AppUser(
      id: HomeSetterPage.auth.currentUser!.uid,
      cName: u.data()!['cname'],
      cNumber: int.parse(u.data()!['cnumber']),
      fullName: u.data()!['fullname'],
      college: u.data()!['college'],
      email: u.data()!['email'],
      intake: int.parse(u.data()!['intake']),
      lat: u.data()!['lat'],
      long: u.data()!['long'],
      pAlways: u.data()!['palways'],
      pLocation: u.data()!['plocation'],
      pMaps: u.data()!['pmaps'],
      pPhone: u.data()!['pphone'],
      photoUrl: u.data()!['photourl'],
      phone: u.data()!['phone'],
      timeStamp: DateTime.parse(u.data()!['lastonline']),
      premium: u.data()!['premium'],
      fbUrl: u.data()!['fburl'],
      instaUrl: u.data()!['instaurl'],
      verified: u.data()!['verified'],
      celeb: u.data()!['celeb'],
      treatHead: u.data()!['treathead'],
      treatHunter: u.data()!['treathunter'],
      workplace: u.data()!['workplace'],
      profession: u.data()!['profession'],
      manualDp: u.data()!['manualdp'],
      treatCount: u.data()!['treatcount'],
    );
  }

  @override
  _HomeSetterPageState createState() => _HomeSetterPageState();
}

class _HomeSetterPageState extends State<HomeSetterPage> {
  User? user;

  loggedInNotifier() {
    setState(() {});
  }

  @override
  void initState() {
    user = HomeSetterPage.auth.currentUser;
    if (user != null) {
      HomeSetterPage.setMainUser(user!);
    }
    HomeSetterPage.auth.authStateChanges().listen(
      (user) {
        if (mounted) {
          if (this.user != user) {
            setState(
              () {
                this.user = user;
                if (user != null) {
                  HomeSetterPage.setMainUser(user);
                } else {
                  HomeSetterPage.mainUser = null;
                }
              },
            );
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen((message) {
      print('Cloud message received(foreground)...');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      flutterNotificationPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            android.channelId ?? channel.id,
            channel.name,
            channel.description,
            color: Theme.of(context).primaryColor,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('On message opened app was published...');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(notification.title!),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body!),
                ],
              ),
            ),
          );
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return FutureBuilder(
        future: HomeSetterPage.store.collection('users').doc(user!.uid).get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() == null) {
                return CompleteAccountPage(
                  loggedInNotifier: loggedInNotifier,
                );
              } else {
                if (HomeSetterPage.mainUser == null)
                  HomeSetterPage.setMainUser(user);

                // Display home
                return RealHome();
              }
            }
          }
          return Scaffold();
        },
      );
    } else {
      // return RealHome();
      return LoginPage();
    }
  }
}
