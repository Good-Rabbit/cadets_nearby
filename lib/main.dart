import 'dart:async';
import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/local_notification_service.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/about.dart';
import 'pages/account.dart';
import 'pages/availed_offer_code.dart';
import 'pages/cancel.dart';
import 'pages/dp_modifier.dart';
import 'pages/help_post.dart';
import 'pages/home_setter.dart';
import 'pages/login.dart';
import 'pages/notifications.dart';
import 'pages/reset.dart';
import 'pages/signup.dart';
import 'pages/support_details.dart';
import 'pages/verification.dart';
import 'pages/verify_cadet.dart';
import 'pages/verify_email.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'important_notifications',
  'Important notifications',
  description: 'Important notifications show up in this channel',
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

SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //! Initialize Ad service
  // AdService.initialize();

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
      ),
      ChangeNotifierProvider(
        create: (context) => LocationStatus(),
      ),
      ChangeNotifierProvider(
        create: (context) => Data(),
      ),
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
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDark = brightness == Brightness.dark;
    systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadets Nearby',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
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
        '/verification': (context) => const VerificationPage(),
        '/notifications': (context) => const NotificationPage(),
        '/supportdetails': (context) => const SupportDetailsPage(),
        '/availedofferdetails': (context) => const AvailedOfferDetailsPage(),
      },
    );
  }
}
