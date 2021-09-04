import 'dart:isolate';

import 'package:cadets_nearby/pages/complete_account_page.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomeSetterPage extends StatefulWidget {
  const HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

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
      context.read<MainUser>().setWithUser(user!);
    }
    HomeSetterPage.auth.authStateChanges().listen(
      (user) {
        if (mounted) {
          if (this.user != user) {
            setState(
              () {
                this.user = user;
                if (user != null) {
                  context.read<MainUser>().setWithUser(user);
                } else {
                  context.read<MainUser>().user = null;
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

        showNotificationDialog(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      LocalNotificationService.display(message);

      context.read<GlobalNotifications>().addNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      context.read<GlobalNotifications>().markMessageAsRead(message);

      showNotificationDialog(message);
    });
    super.initState();
  }

  void showNotificationDialog(RemoteMessage message) {
    final RemoteNotification notification = message.notification!;

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
                if (message.data['url'] != '')
                  TextButton(
                      onPressed: () {
                        launchURL(message.data['url'] as String);
                      },
                      child: Text(message.data['url'] as String)),
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
                if (context.watch<MainUser>().user == null) {
                  context.read<MainUser>().setWithUser(user!);
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
