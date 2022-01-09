import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';

class AvailedOfferDetailsPage extends StatefulWidget {
  const AvailedOfferDetailsPage({Key? key}) : super(key: key);

  @override
  _AvailedOfferDetailsPageState createState() =>
      _AvailedOfferDetailsPageState();
}

class _AvailedOfferDetailsPageState extends State<AvailedOfferDetailsPage> {
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  @override
  Widget build(BuildContext context) {
    e = ModalRoute.of(context)!.settings.arguments
        as QueryDocumentSnapshot<Map<String, dynamic>>;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.headline6,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.qr_code),
            SizedBox(
              width: 10,
            ),
            Text(
              'Scan code at the offer place',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e!.data()['title'],
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.orange[50],
                ),
                child: QrImage(
                  data: e!.data()['code'],
                  embeddedImage: const AssetImage('assets/images/icon.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(50, 50),
                  ),
                  version: QrVersions.auto,
                  size: 250,
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text(
                        'Uh oh! Something went wrong...',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
