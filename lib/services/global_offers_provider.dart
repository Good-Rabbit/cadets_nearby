import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GlobalOffers with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? dataStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? dataSubscription;

  List<Map<String, dynamic>> offers = [];

  GlobalOffers() {
    initialize();
  }

  Future<void> initialize() async {
    dataStream = FirebaseFirestore.instance
        .collection('offers')
        .where('scope', isEqualTo: 'global')
        .snapshots();
    dataSubscription = dataStream!.listen((event) {
      offers = event.docs.map((doc) => doc.data()).toList();
      offers.sort((a, b) => a['priority'] - b['priority']);
      notifyListeners();
    });
  }
}
