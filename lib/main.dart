import 'dart:async';
import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/pages/about.dart';
import 'package:cadets_nearby/pages/account.dart';
import 'package:cadets_nearby/pages/cancel.dart';
import 'package:cadets_nearby/pages/dp_modifier.dart';
import 'package:cadets_nearby/pages/help_post.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/notifications.dart';
import 'package:cadets_nearby/pages/reset.dart';
import 'package:cadets_nearby/pages/signup.dart';
import 'package:cadets_nearby/pages/support_details.dart';
import 'package:cadets_nearby/pages/verification.dart';
import 'package:cadets_nearby/pages/verify_cadet.dart';
import 'package:cadets_nearby/pages/verify_email.dart';
import 'package:cadets_nearby/services/ad_service.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/availed_offer_code.dart';
import 'pages/availed_offers.dart';
import 'pages/offer_details.dart';

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

const systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AdService.initialize();

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

  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => GlobalNotifications(),
      ),
      ChangeNotifierProvider(
        create: (context) => MainUser(),
      ),
      ChangeNotifierProvider(
        create: (context) => Settings(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadets Nearby',
      theme: lightTheme,
      routes: {
        '/': (context) => const HomeSetterPage(),
        '/about': (context) => const AboutPage(),
        '/login': (context) => const LoginPage(),
        '/reset': (context) => const ResetPage(),
        '/signup': (context) => const SignupMainPage(),
        '/cancel': (context) => const CancelVerificationPage(),
        '/account': (context) => const AccountPage(),
        '/posthelp': (context) => const PostHelpPage(),
        '/dpchange': (context) => const DpPage(),
        '/verifycadet': (context) => const CadetVerificationPage(),
        '/verifyemail': (context) => const EmailVerificationPage(),
        '/offerdetails': (context) => const OfferDetailsPage(),
        '/verification': (context) => const VerificationPage(),
        '/notifications': (context) => const NotificationPage(),
        '/supportdetails': (context) => const SupportDetailsPage(),
        '/availedoffers': (context) => const AvailedOffersPage(),
        '/availedofferdetails': (context) => const AvailedOfferDetailsPage(),

      },
    );
  }
}
