import 'package:cadets_nearby/data/appData.dart';
import 'package:cadets_nearby/pages/cancel.dart';
import 'package:cadets_nearby/pages/dpModifier.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/pages/init.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/pages/reset.dart';
import 'package:cadets_nearby/pages/signup.dart';
import 'package:cadets_nearby/pages/verification.dart';
import 'package:cadets_nearby/pages/verifyCadet.dart';
import 'package:cadets_nearby/pages/verifyEmail.dart';
import 'package:cadets_nearby/services/localNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'important_notifications',
  'Important notifications',
  'Important notifications show up in this channel',
  importance: Importance.max,
  playSound: true,
);

List<String> notifications = [];

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('New background message : ${message.messageId}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  notifications = prefs.getStringList('notifications') ?? [];
  notifications.add(
    message.notification!.title! +
        '~' +
        message.notification!.body! +
        '~' +
        'u' +
        '~' +
        message.sentTime!.toString(),
  );
  prefs.setStringList('notifications', notifications);
  prefs.reload();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    print(e);
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

  await getNotifications();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  runApp(MyApp());
}

Future<void> getNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  notifications = prefs.getStringList('notifications') ?? [];
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
      initialRoute: '/',
      routes: {
        '/': (context) => InitPage(),
        '/home': (context) => HomeSetterPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupMainPage(),
        '/reset': (context) => ResetPage(),
        '/cancel': (context) => CancelVerificationPage(),
        '/verifycadet': (context) => CadetVerificationPage(),
        '/verifyemail': (context) => EmailVerificationPage(),
        '/verification': (context) => VerificationPage(),
        '/dpchange': (context) => DpPage(),
      },
    );
  }
}
