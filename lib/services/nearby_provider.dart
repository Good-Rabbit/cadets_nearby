import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nearby with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? users;
  TextEditingController intakeTextController = TextEditingController();
  int intakeYear = 0;
  int daysRange = 30;
  String collegeName = 'All Colleges';
  String range = '2000 m';

  SharedPreferences? prefs;

  Nearby() {
    initiatePref();
    intakeTextController.addListener(() {
      if (intakeTextController.text != '') {
        intakeYear = int.parse(intakeTextController.text);
      }
    });
  }

  initiatePref() async {
    prefs = await SharedPreferences.getInstance();
    loadFilterFromPref();
  }

  void loadFilterFromPref() {
      range = (prefs!.getString('range') ?? range);
  }

  int get days => daysRange;

  set days(int days) {
    daysRange = days;
  }

  int get intake => intakeYear;

  set college(college) {
    collegeName = college;
  }

  get college => collegeName;
}
