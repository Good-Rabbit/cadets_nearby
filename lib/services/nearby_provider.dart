import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nearby with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? users;
  TextEditingController intakeTextController = TextEditingController();
  int intakeYear = 0;
  int daysRange = 30;
  String collegeName = 'Select college';
  RangeValues range = const RangeValues(0, 5);

  Nearby() {
    intakeTextController.addListener(() {
      if(intakeTextController.text != '') {
        intakeYear = int.parse(intakeTextController.text);
      }
    });
  }

  int get days => daysRange;

  set days(int value) {
    daysRange = value;
    notifyListeners();
  }

  get intake => intakeYear;

  set college(college) {
    collegeName = college;
    notifyListeners();
  }

  get college => collegeName;
}
