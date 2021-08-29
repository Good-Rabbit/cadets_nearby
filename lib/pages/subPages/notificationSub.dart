import 'package:flutter/material.dart';
import 'package:cadets_nearby/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSubPage extends StatefulWidget {
  NotificationSubPage({Key? key}) : super(key: key);

  @override
  _NotificationSubPageState createState() => _NotificationSubPageState();
}

class _NotificationSubPageState extends State<NotificationSubPage>
    with AutomaticKeepAliveClientMixin {
  Future<void> markRead(String notification) async {
    List<String> nrl = notification.split('~');
    String nr = nrl[0] + '~' + nrl[1] + '~' + 'r';
    notifications[notifications.indexOf(notification)] = nr;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notifications', notifications);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return;
      },
      child: Center(
        child: notifications.length != 0
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ListView(
                  children: notifications.map((e) {
                    List<String> notification = e.split('~');
                    return InkWell(
                      onTap: () {
                        setState(() {
                          markRead(e);
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  notification[2] == 'u'
                                      ? Icons.notifications_active
                                      : Icons.notifications,
                                  color:notification[2] == 'u'
                                      ? Theme.of(context).primaryColor
                                      : Colors.brown,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification[0],
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(notification[1]),
                                  ),
                                ],
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
