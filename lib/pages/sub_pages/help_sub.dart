
import 'package:flutter/material.dart';

class AboutSubPage extends StatefulWidget {
  const AboutSubPage({Key? key}) : super(key: key);

  @override
  _AboutSubPageState createState() => _AboutSubPageState();
}

class _AboutSubPageState extends State<AboutSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SafeArea(
      child: Center(
        child: Text('Help Page'),),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
