import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationStatus with ChangeNotifier {
  bool serviceEnabled;
  bool permissionGranted;
  final Location location = Location();

  LocationStatus({this.serviceEnabled = true, this.permissionGranted = false}) {
    checkPermissions();
  }

  checkPermissions() async {
    bool sTemp = serviceEnabled;
    bool pTemp = permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    permissionGranted =
        await location.hasPermission() == PermissionStatus.granted;
        
    if (sTemp != serviceEnabled || pTemp != permissionGranted) {
      notifyListeners();
    }
  }

  getPermissions() async {
    bool sTemp = serviceEnabled;
    bool pTemp = permissionGranted;

    serviceEnabled = await location.requestService();
    permissionGranted =
        (await location.requestPermission()) == PermissionStatus.granted;
    if (sTemp != serviceEnabled || pTemp != permissionGranted) {
      notifyListeners();
    }
  }
}
