import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/pages/cancel.dart';
import 'package:cadets_nearby/pages/dp_modifier.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/notifications.dart';
import 'package:cadets_nearby/pages/reset.dart';
import 'package:cadets_nearby/pages/signup.dart';
import 'package:cadets_nearby/pages/verification.dart';
import 'package:cadets_nearby/pages/verify_cadet.dart';
import 'package:cadets_nearby/pages/verify_email.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'important_notifications',
  'Important notifications',
  'Important notifications show up in this channel',
  importance: Importance.max,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final List<String> notifications = prefs.getStringList('notifications') ?? [];
  notifications.add(
    '${message.notification!.title!}~${message.notification!.body!}~u~${message.sentTime!.toString()}~${message.data['url']}',
  );
  prefs.setStringList('notifications', notifications);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    log(e.toString());
  }
  await LocalNotificationService.notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => GlobalNotifications(),
      ),
      ChangeNotifierProvider(
        create: (context) => MainUser(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cadets_nearby',
      theme: lightTheme,
      routes: {
        '/': (context) => const HomeSetterPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupMainPage(),
        '/reset': (context) => const ResetPage(),
        '/cancel': (context) => const CancelVerificationPage(),
        '/verifycadet': (context) => const CadetVerificationPage(),
        '/verifyemail': (context) => const EmailVerificationPage(),
        '/verification': (context) => const VerificationPage(),
        '/dpchange': (context) => const DpPage(),
        '/notifications': (context) => const NotificationPage(),
      },
    );
  }
}
