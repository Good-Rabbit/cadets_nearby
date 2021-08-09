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
      child: Container(
        child: Text('Notification Page'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
