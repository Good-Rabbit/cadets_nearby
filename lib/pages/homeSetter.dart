import 'package:cadets_nearby/pages/completeAccountPage.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/uiElements/loading.dart';
import 'package:cadets_nearby/services/localNotificationService.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class HomeSetterPage extends StatefulWidget {
  HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
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
      sector: u.data()!['sector'],
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
    LocalNotificationService.initialize(context);
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

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      notifications = prefs.getStringList('notifications') ?? [];
      if (message != null) {
        RemoteNotification notification = message.notification!;
        // AndroidNotification android = message.notification!.android!;

        markRead(message);

        showNotificationDialog(notification);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      print('Cloud message received(foreground)...');
      RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;

      LocalNotificationService.display(message);

      updateNotifications(notification, message.sentTime!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('On message opened app was published...');
      RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;

      markRead(message);

      showNotificationDialog(notification);
    });
    super.initState();
  }

  void showNotificationDialog(RemoteNotification notification) {
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
  }

  Future<void> updateNotifications(
      RemoteNotification notification, DateTime timeStamp) async {
    notifications.add(notification.title! +
        '~' +
        notification.body! +
        '~' +
        'u' +
        '~' +
        timeStamp.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notifications', notifications);
  }

  Future<void> markRead(RemoteMessage message) async {
    String nf = message.notification!.title! +
        '~' +
        message.notification!.body! +
        '~' +
        'u' +
        '~' +
        message.sentTime.toString();
    String nr = nf.replaceFirst('~u~', '~r~');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications = prefs.getStringList('notifications') ?? [];
    notifications[notifications.indexOf(nf)] = nr;
    prefs.setStringList('notifications', notifications);
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
                if (!HomeSetterPage.auth.currentUser!.emailVerified) {
                  verifyEmail();
                  return Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                  );
                }
                return CompleteAccountPage(
                  loggedInNotifier: loggedInNotifier,
                );
              } else {
                if (HomeSetterPage.mainUser == null)
                  HomeSetterPage.setMainUser(user);

                if (!HomeSetterPage.auth.currentUser!.emailVerified) {
                  verifyEmail();
                  return Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                  );
                }
                // Display home
                return RealHome();
              }
            }
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(child: Loading()),
          );
        },
      );
    } else {
      // return RealHome();
      return LoginPage();
    }
  }

  verifyEmail() {
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => Navigator.of(context).pushNamed('/verifyemail'));
  }
}
