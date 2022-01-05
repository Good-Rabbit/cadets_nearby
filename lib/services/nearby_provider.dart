import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nearby with ChangeNotifier {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? users;
  TextEditingController intakeTextController = TextEditingController();
  int intakeYear = 0;
  int daysRange = 30;
  String collegeName = 'Select college';
  RangeValues _range = const RangeValues(0, 5);

  bool _saveFilter = false;
  SharedPreferences? prefs;

  bool get saveFilter => _saveFilter;

  set saveFilter(bool value) {
    _saveFilter = value;
    prefs!.setBool('saveFilter', _saveFilter);
    if (value) {
      saveFilterToPref();
    }
    notifyListeners();
  }

  Nearby() {
    initiatePref();
    intakeTextController.addListener(() {
      if (intakeTextController.text != '') {
        intakeYear = int.parse(intakeTextController.text);
        saveFilterToPref();
      }
    });
  }

  initiatePref() async {
    prefs = await SharedPreferences.getInstance();
    loadFilterFromPref();
  }

  void loadFilterFromPref() {
    _saveFilter = prefs!.getBool('saveFilter') ?? false;
    if (_saveFilter) {
      //! Load filters
      range = prefs!.getInt('rangeStart') != null
          ? RangeValues(prefs!.getInt('rangeStart')!.toDouble(),
              prefs!.getInt('rangeEnd')!.toDouble())
          : range;
    }
  }

  void saveFilterToPref() {
    //! Save filters
    if (_saveFilter) {
      prefs!.setInt('rangeStart', range.start.toInt());
      prefs!.setInt('rangeEnd', range.end.toInt());
    }
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

  RangeValues get range => _range;

  set range(RangeValues range) {
    _range = range;
    saveFilterToPref();
  }
}
