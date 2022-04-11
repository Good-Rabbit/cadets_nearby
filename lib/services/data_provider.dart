import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  String? quoteData;
  String? rateLinkData;
  String? grLinkData;
  String? cnLinkData;
  String? privacyPolicyData;
  String? termsConditionsData;
  int buildNumber = 0;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? dataStream;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? dataSubscription;

  Data() {
    initialize();
  }

  Future<void> initialize() async {
    dataStream ??=
        FirebaseFirestore.instance.collection('data').doc('1').snapshots();
    dataSubscription ??= dataStream!.listen((event) {
      quoteData = event.data()!['quote'];
      rateLinkData = event.data()!['ratelink'];
      cnLinkData = event.data()!['cnlink'];
      grLinkData = event.data()!['grlink'];
      termsConditionsData = event.data()!['termsconditions'];
      privacyPolicyData = event.data()!['privacypolicy'];
      buildNumber = event.data()!['build'];
      notifyListeners();
    });
  }

  get quote => quoteData;
  get rateLink => rateLinkData;
  get cnLink => cnLinkData;
  get grLink => grLinkData;
  get termsConditions => termsConditionsData;
  get privacyPolicy => privacyPolicyData;
}
