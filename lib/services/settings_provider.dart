import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  bool zoneDetectionBool;

  Settings({this.zoneDetectionBool = true,}) {
    initialize();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    zoneDetectionBool = prefs.getBool('zoneDetection') ?? true;
  }

  bool get zoneDetection => zoneDetectionBool;
  set zoneDetection(bool zoneDetection) {
    zoneDetectionBool = zoneDetection;
    notifyListeners();
    update();
  }

  Future<void> update()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('zoneDetection', zoneDetectionBool);
  }
}
