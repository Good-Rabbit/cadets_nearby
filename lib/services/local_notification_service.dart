import 'dart:developer';

import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      final Noti notification = Noti(notificationString: notificationResponse.payload!);

      markRead(notificationResponse.payload!);
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
                  if (notification.url != '')
                    TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse(notification.url),mode: LaunchMode.externalApplication);
                        },
                        child: Text(notification.url)),
                ],
              ),
            ),
          );
        },
      );
    },
    );
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
            channelDescription: channel.description,
            importance: Importance.max,
            icon: '@mipmap/ic_launcher',
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
