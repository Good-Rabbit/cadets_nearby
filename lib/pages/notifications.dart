import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(
                width: 10,
              ),
              Text(
                'Notifications',
              ),
            ],
          ),
        ),
        body: Center(
          child: SafeArea(
            child: context
                    .watch<GlobalNotifications>()
                    .allNotification
                    .isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ListView(
                      children: Provider.of<GlobalNotifications>(context)
                          .allNotification
                          .map((e) {
                        final List<String> dt = e.timeStamp.split(' ');
                        final List<String> dateTemp = dt[0].split('-');
                        final String date =
                            '${dateTemp[2]}/${dateTemp[1]}/${dateTemp[2]}';
                        final List<String> t = dt[1].split(':');
                        final String time = '${t[0]}:${t[1]}';
                        return InkWell(
                          onTap: () {
                            context
                                .read<GlobalNotifications>()
                                .markNotificationAsRead(e.notificationString);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(e.title),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.body),
                                        if (e.url != '')
                                          TextButton(
                                              onPressed: () {
                                                launchUrl(Uri.parse(e.url),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                              child: Text(e.url)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 20, 15),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      !e.isRead
                                          ? Icons.notifications_active
                                          : Icons.notifications,
                                      color: !e.isRead
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                          style: const TextStyle(fontSize: 17),
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
                                                '$time  $date',
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'No Notification',
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.primary,
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
