import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NearbyOffers with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> nearbyOffers = [];

  void add(QueryDocumentSnapshot<Map<String, dynamic>> offer) {
    bool contains = false;
    for (final e in nearbyOffers) {
      if (e.id == offer.id) {
        contains = true;
        break;
      }
    }
    if (!contains) {
      nearbyOffers.add(offer);
      notifyListeners();
    }
  }

  // void remove(QueryDocumentSnapshot<Map<String, dynamic>> offer) {
  //   if (nearbyOffers.contains(offer)) {
  //     nearbyOffers.remove(offer);
  //   }
  //   notifyListeners();
  // }
}
