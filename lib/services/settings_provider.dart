import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  bool zoneDetectionBool;
  bool rewardGained = false;

  Settings({this.zoneDetectionBool = true, this.rewardGained = false}) {
    initialize();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    if (prefs.getBool('zoneDetection') == null) {
      prefs.setBool('zoneDetection', true);
      zoneDetection = true;
    } else {
      zoneDetectionBool = prefs.getBool('zoneDetection') ?? true;
    }
  }

  bool get zoneDetection => zoneDetectionBool;
  set zoneDetection(bool zoneDetection) {
    zoneDetectionBool = zoneDetection;
    notifyListeners();
    update();
  }

  Future<void> update() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('zoneDetection', zoneDetectionBool);
  }

  set reward(bool reward) {
    rewardGained = reward;
    notifyListeners();
  }

  bool get reward => rewardGained;
}
