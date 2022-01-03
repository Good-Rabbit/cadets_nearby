import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nearby with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? users;
  TextEditingController intakeTextController = TextEditingController();
  int intakeYear = 0;
  String collegeName = 'Select college';
  RangeValues range = const RangeValues(0, 5);

  Nearby() {
    intakeTextController.addListener(() {
      intakeYear = int.parse(intakeTextController.text);
      notifyListeners();
    });
  }

  get intake => intakeYear;

  set college(college) {
    collegeName = college;
    nearbyUsers(users);
    notifyListeners();
  }

  get college => collegeName;

  set rangeSliderValues(range) {
    this.range = range;
    nearbyUsers(users);
    notifyListeners();
  }

  get rangeSliderValues => range;

  set nearbyUsers(users) {
    this.users = users;
    notifyListeners();
  }

  get nearbyUsers => users;
}
