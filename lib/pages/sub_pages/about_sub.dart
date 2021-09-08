
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
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Icon(
              Icons.info_outline_rounded,
              size: 100,
              color: Colors.red,
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: const Text(
                'Cadets Nearby is a system by the cadets, for the cadets. With this, you can easily find cadets who are nearby. Making it very convenient for you to find and communicate with each other.',
                style: TextStyle(
                  fontSize: 15,
                ),
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
