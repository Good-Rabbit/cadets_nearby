import 'package:flutter/material.dart';

class AboutSubPage extends StatefulWidget {
  AboutSubPage({Key? key}) : super(key: key);

  @override
  _AboutSubPageState createState() => _AboutSubPageState();
}

class _AboutSubPageState extends State<AboutSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Container(
        child: Text('About Page'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
