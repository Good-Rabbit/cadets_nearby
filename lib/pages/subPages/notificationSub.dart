import 'package:flutter/material.dart';

class NotificationSubPage extends StatefulWidget {
  NotificationSubPage({Key? key}) : super(key: key);

  @override
  _NotificationSubPageState createState() => _NotificationSubPageState();
}

class _NotificationSubPageState extends State<NotificationSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Column(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
