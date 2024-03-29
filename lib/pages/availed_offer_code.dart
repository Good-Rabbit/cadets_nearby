import 'package:cadets_nearby/data/snackbar_mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AvailedOfferDetailsPage extends StatefulWidget {
  const AvailedOfferDetailsPage({Key? key}) : super(key: key);

  @override
  AvailedOfferDetailsPageState createState() => AvailedOfferDetailsPageState();
}

class AvailedOfferDetailsPageState extends State<AvailedOfferDetailsPage>
    with AsyncSnackbar {
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  @override
  Widget build(BuildContext context) {
    e = ModalRoute.of(context)!.settings.arguments
        as QueryDocumentSnapshot<Map<String, dynamic>>;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        title: const Row(
          children: [
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
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(
              height: 10,
            ),
            FilledButton.icon(
              onPressed: () {
                copyToClipboard();
              },
              icon: Icon(Icons.copy_rounded,
                  color: Theme.of(context).colorScheme.primary),
              label: Text(
                'Copy code',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary.withAlpha(60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: e!.data()['code']));
    showSnackbar('Copied to clipboard');
  }
}
