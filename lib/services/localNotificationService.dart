import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> markRead(String notification) async {
    String nr = notification.replaceFirst('~u~', '~r~');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications = prefs.getStringList('notifications') ?? [];
    notifications[notifications.indexOf(notification)] = nr;
    prefs.setStringList('notifications', notifications);
  }

  static void initialize(context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      Noti notification = Noti(notificationString: payload!);

      markRead(payload);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(notification.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  static void display(RemoteMessage message) async {
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
        payload:
            '${message.notification!.title}~${message.notification!.body}~u~${message.sentTime.toString()}',
      );
    } catch (e) {
      print(e);
    }
  }
}
