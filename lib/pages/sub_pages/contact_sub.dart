import 'package:flutter/material.dart';

class ContactSubPage extends StatefulWidget {
  const ContactSubPage({Key? key}) : super(key: key);

  @override
  _ContactSubPageState createState() => _ContactSubPageState();
}

class _ContactSubPageState extends State<ContactSubPage>
    with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: const [
            SizedBox(
              height: 30,
            ),
            Text(
              'Contacts',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
