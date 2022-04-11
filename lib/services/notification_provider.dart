import 'package:cadets_nearby/services/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalNotifications with ChangeNotifier {
  List<Noti> notifications = [];
  bool isAnyUnread = false;

  GlobalNotifications() {
    initialize();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String> notificationsStringList =
        prefs.getStringList('notifications') ?? [];
    notifications = notificationsStringList.map((e) {
      return Noti(notificationString: e);
    }).toList();

    checkNewnotification();
    sortNotifications();
    notifyListeners();
  }

  void checkNewnotification() {
    bool temp = false;
    for (final notification in notifications) {
      if (!notification.isRead) {
        temp = true;
        break;
      }
    }
    if (temp) {
      isAnyUnread = true;
    } else {
      isAnyUnread = false;
    }
  }

  bool get hasUnread => isAnyUnread;

  List<Noti> get allNotification => notifications;

  Future<void> addNotification(RemoteMessage message) async {
    final Noti noti = Noti(
      notificationString:
          '${message.notification!.title}~${message.notification!.body}~u~${message.sentTime.toString()}~${message.data['url']}',
    );
    notifications.add(noti);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String> notificationsString =
        prefs.getStringList('notifications') ?? [];
    notificationsString.add(
      '${message.notification!.title!}~${message.notification!.body!}~u~${message.sentTime!.toString()}~${message.data['url']}',
    );
    prefs.setStringList('notifications', notificationsString);

    checkNewnotification();
    sortNotifications();
    notifyListeners();
  }

  void sortNotifications() {
    notifications.sort((b, a) {
      return a.timeStamp.compareTo(b.timeStamp);
    });
  }

  Future<void> markMessageAsRead(RemoteMessage message) async {
    final String nf =
        '${message.notification!.title}~${message.notification!.body}~u~${message.sentTime.toString()}';
    final String nr = nf.replaceFirst('~u~', '~r~');

    final Noti nrr = Noti(notificationString: nr);
    final int index = notifications.indexWhere(
        (element) => element.notificationString == nf);
    notifications[index] = nrr;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String> notificationsStringList =
        prefs.getStringList('notifications') ?? [];
    notificationsStringList[notificationsStringList.indexOf(nf)] = nr;
    prefs.setStringList('notifications', notificationsStringList);
    checkNewnotification();

    notifyListeners();
  }

  Future<void> markNotificationAsRead(String nf) async {
    final String nr = nf.replaceFirst('~u~', '~r~');

    final Noti nrr = Noti(notificationString: nr);
    final int index = notifications.indexWhere(
        (element) => element.notificationString == nf);
    notifications[index] = nrr;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String> notificationsStringList =
        prefs.getStringList('notifications') ?? [];
    notificationsStringList[notificationsStringList.indexOf(nf)] = nr;
    prefs.setStringList('notifications', notificationsStringList);
    checkNewnotification();

    notifyListeners();
  }
}
