import 'package:flutter/material.dart';

class MessageSubPage extends StatefulWidget {
  MessageSubPage({Key? key}) : super(key: key);

  @override
  _MessageSubPageState createState() => _MessageSubPageState();
}

class _MessageSubPageState extends State<MessageSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Container(
        child: Text('Messages Page'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
