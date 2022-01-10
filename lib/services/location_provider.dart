import 'dart:developer';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationStatus with ChangeNotifier {
  bool serviceEnabled;
  bool permissionGranted;
  double latMax = 0;
  double latMin = 0;
  LocationData? locationData;
  final Location location = Location();

  LocationStatus({this.serviceEnabled = true, this.permissionGranted = false}) {
    checkPermissions();
  }

  void calculateMinMax() {
    latMax = locationData!.latitude! + 0.138;
    latMin = locationData!.latitude! - 0.138;
  }

  Future<void> getLocation() async {
    try {
      final Location location = Location();

      serviceEnabled = await location.serviceEnabled();

      checkPermissions();

      locationData = await location.getLocation();
      log(locationData!.latitude.toString() +'  '+
          locationData!.longitude.toString());
      //Calculate minimum and maximum for other distances
      // ignore: use_build_context_synchronously
      calculateMinMax();
      uploadLocation(locationData!);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void uploadLocation(LocationData locationData) {
    int sector = 0;
    sector = ((locationData.latitude! - 20.56666) / (0.046)).ceil();
    final String timeStamp = DateTime.now().toString();
    try {
      HomeSetterPage.store
          .collection('users')
          .doc(HomeSetterPage.auth.currentUser!.uid)
          .update({
        'lat': locationData.latitude,
        'long': locationData.longitude,
        'sector': sector,
        'lastonline': timeStamp,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  checkPermissions() async {
    bool sTemp = serviceEnabled;
    bool pTemp = permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    permissionGranted =
        await location.hasPermission() == PermissionStatus.granted;
    if (!permissionGranted) {
      permissionGranted =
          await location.requestPermission() == PermissionStatus.granted;
    }

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
