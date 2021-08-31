import 'dart:developer';

import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> markRead(String notification) async {
    final String nr = notification.replaceFirst('~u~', '~r~');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> notifications =
        prefs.getStringList('notifications') ?? [];
    notifications[notifications.indexOf(notification)] = nr;
    prefs.setStringList('notifications', notifications);
  }

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      final Noti notification = Noti(notificationString: payload!);

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

  static dynamic display(RemoteMessage message) async {
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
          ),
        ),
        payload:
            '${message.notification!.title}~${message.notification!.body}~u~${message.sentTime.toString()}',
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
