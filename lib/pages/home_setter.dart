import 'package:cadets_nearby/pages/complete_account_page.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSetterPage extends StatefulWidget {
  const HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static AppUser? mainUser;
  static Future<void> setMainUser(User? user) async {
    final u =
        await HomeSetterPage.store.collection('users').doc(user!.uid).get();
    HomeSetterPage.mainUser = AppUser(
      id: HomeSetterPage.auth.currentUser!.uid,
      cName: u.data()!['cname'] as String,
      cNumber: int.parse(u.data()!['cnumber'] as String),
      fullName: u.data()!['fullname'] as String,
      college: u.data()!['college'] as String,
      email: u.data()!['email'] as String,
      intake: int.parse(u.data()!['intake'] as String),
      lat: u.data()!['lat'] as double,
      long: u.data()!['long'] as double,
      pAlways: u.data()!['palways'] as bool,
      pLocation: u.data()!['plocation'] as bool,
      pMaps: u.data()!['pmaps'] as bool,
      pPhone: u.data()!['pphone'] as bool,
      photoUrl: u.data()!['photourl'] as String,
      phone: u.data()!['phone'] as String,
      timeStamp: DateTime.parse(u.data()!['lastonline'] as String),
      premium: u.data()!['premium'] as bool,
      fbUrl: u.data()!['fburl'] as String,
      instaUrl: u.data()!['instaurl'] as String,
      verified: u.data()!['verified'] as String,
      celeb: u.data()!['celeb'] as bool,
      treatHead: u.data()!['treathead'] as bool,
      treatHunter: u.data()!['treathunter'] as bool,
      designation: u.data()!['designation'] as String,
      profession: u.data()!['profession'] as String,
      manualDp: u.data()!['manualdp'] as bool,
      treatCount: u.data()!['treatcount'] as int,
      sector: u.data()!['sector'] as int,
      district: u.data()!['district'] as String,
    );
  }

  @override
  _HomeSetterPageState createState() => _HomeSetterPageState();
}

class _HomeSetterPageState extends State<HomeSetterPage> {
  User? user;

  void loggedInNotifier() {
    setState(() {});
  }

  @override
  void initState() {
    LocalNotificationService.initialize(context);
    user = HomeSetterPage.auth.currentUser;
    if (user != null) {
      HomeSetterPage.setMainUser(user);
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
      if (message != null) {
        context.read<GlobalNotifications>().markMessageAsRead(message);

        showNotificationDialog(message.notification!);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      LocalNotificationService.display(message);

      context.read<GlobalNotifications>().addNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;

      context.read<GlobalNotifications>().markMessageAsRead(message);

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
                if (HomeSetterPage.mainUser == null) {
                  HomeSetterPage.setMainUser(user);
                }

                if (!HomeSetterPage.auth.currentUser!.emailVerified) {
                  verifyEmail();
                  return Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                  );
                }
                // Display home
                return const RealHome();
              }
            }
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: const Center(child: Loading()),
          );
        },
      );
    } else {
      // return RealHome();
      return const LoginPage();
    }
  }

  void verifyEmail() {
    Future.delayed(Duration.zero)
        .then((value) => Navigator.of(context).pushNamed('/verifyemail'));
  }
}
