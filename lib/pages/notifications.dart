import 'package:cadets_nearby/pages/subPages/homeSub.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  Future<void> markRead(String notification) async {
    List<String> nrl = notification.split('~');
    String nr = '${nrl[0]}~${nrl[1]}~r~${nrl[3]}';
    notifications[notifications.indexOf(notification)] = nr;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notifications', notifications);
  }

  bool justNow = false;
  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var temp = notifications;
    notifications = prefs.getStringList('notifications') ?? [];
    if (temp != notifications) {
      setState(() {
        justNow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!justNow) {
      getNotifications();
    } else {
      justNow = false;
    }

    HomeSubPage.nots = notifications.map((e) {
      return Noti(notificationString: e);
    }).toList();

    HomeSubPage.nots.sort((a, b) {
      return b.timeStamp.compareTo(a.timeStamp);
    });

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: SafeArea(
            child: notifications.length != 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ListView(
                      children: HomeSubPage.nots.map((e) {
                        List<String> dt = e.timeStamp.split(' ');
                        List<String> dateTemp = dt[0].split('-');
                        String date =
                            '${dateTemp[2]}/${dateTemp[1]}/${dateTemp[2]}';
                        List<String> t = dt[1].split(':');
                        String time = '${t[0]}:${t[1]}';
                        return InkWell(
                          onTap: () {
                            setState(() {
                              markRead(e.notificationString);
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 20, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      !e.isRead
                                          ? Icons.notifications_active
                                          : Icons.notifications,
                                      color: !e.isRead
                                          ? Theme.of(context).primaryColor
                                          : Colors.brown,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.title,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Text(
                                          e.body,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                              child: Text(
                                                time + '  ' + date,
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 70,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'No Notification',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
