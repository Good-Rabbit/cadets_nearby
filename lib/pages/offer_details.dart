import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class OfferDetailsPage extends StatefulWidget {
  const OfferDetailsPage({Key? key}) : super(key: key);

  @override
  OfferDetailsPageState createState() => OfferDetailsPageState();
}

class OfferDetailsPageState extends State<OfferDetailsPage> {
  Map<String, dynamic>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  String distance = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    e = data!['e'] as QueryDocumentSnapshot<Map<String, dynamic>>;
    distance = data!['distance'];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.backpack),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'Details',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                Text(
                  e!.data()['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 23),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  e!.data()['minidescription'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  e!.data()['description'],
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Address: ${e!.data()['address']}, ${e!.data()['district']}',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Distance: $distance',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
