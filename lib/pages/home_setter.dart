import 'dart:developer';

import 'package:cadets_nearby/pages/complete_account_page.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeSetterPage extends StatefulWidget {
  const HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  HomeSetterPageState createState() => HomeSetterPageState();
}

class HomeSetterPageState extends State<HomeSetterPage> {
  User? user;

  int localBuild = 0;

  void getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localBuild = int.parse(packageInfo.buildNumber);
    log('Version: $localBuild');
  }

  @override
  void initState() {
    getBuildNumber();
    context.read<LocationStatus>().checkPermissions();

    // Init Notifications
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
    // if (context.read<LocationStatus>().serviceEnabled &&
    //     context.read<LocationStatus>().permissionGranted) {
    if (context.watch<Data>().buildNumber > localBuild) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A new version of Cadets Nearby is available. Please update to the latest version.',
                style: TextStyle(
                    fontSize: 25, color: Theme.of(context).primaryColor),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    launchURL(context.read<Data>().rateLinkData!);
                  },
                  icon: const Icon(Icons.upgrade_rounded),
                  label: const Text('Update Now'))
            ],
          ),
        ),
      );
    } else {
      if (user != null) {
        //!Verify e-mail if not done
        if (!user!.emailVerified) {
          verifyEmail();
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
          );
        }
        //!Check if account is complete
        else if (context.watch<MainUser>().user == null) {
          return FutureBuilder(
              future:
                  HomeSetterPage.store.collection('users').doc(user!.uid).get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.data() == null) {
                      return const CompleteAccountPage();
                    } else {
                      context.read<MainUser>().setWithUser(user!);
                    }
                  }
                  // context.read<LocationStatus>().checkPermissions();

                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    body: const Center(child: Loading()),
                  );
                }
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: const Center(child: Loading()),
                );
              });
        }
        //!If incomplete account
        else {
          return const RealHome();
        }
      } else {
        context.read<LocationStatus>().checkPermissions();

        return const LoginPage();
      }
    }
    // } else {
    //   context.read<LocationStatus>().checkPermissions();
    //   return const NotGranted();
    // }
  }

  void verifyEmail() {
    Future.delayed(Duration.zero)
        .then((value) => Navigator.of(context).pushNamed('/verifyemail'));
  }
}
