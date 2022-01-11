import 'dart:async';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Offers extends ChangeNotifier{
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _offers = [];
  Stream? offerStream;
  StreamSubscription<dynamic>? offerSubscription;
  int count = 0;
  int _range = 150;

  int get range => _range;

  set range(int range) {
    _range = range;
    _offers = _offers;
    notifyListeners();
  }

  Offers(){
    offerStream = HomeSetterPage.store
          .collection('offers')
          .orderBy('priority')
          .snapshots();
    offerSubscription = offerStream!.listen((value) {
      final QuerySnapshot<Map<String, dynamic>> snapshots = value as QuerySnapshot<Map<String, dynamic>>;
      _offers = snapshots.docs;
      notifyListeners();
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get offers{
    return [..._offers];
  }

}