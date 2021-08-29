import 'package:cadets_nearby/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message)async{
    try {
        await notificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              importance: Importance.max,
              icon: '@mipmap/launcher_icon',
              priority: Priority.high,
              playSound: true,
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
  }
}
