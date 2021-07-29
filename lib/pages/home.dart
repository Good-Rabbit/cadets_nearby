import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'package:readiew/services/user.dart';

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  _RealHomeState createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
  bool locationEnabled = false;
  bool permissionGranted = false;
  bool rejected = false;
  bool updateFlag = false;
  LocationData? locationData;

  getLocation() async {
    print('Getting location...');

    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      locationEnabled = _serviceEnabled;
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          setState(() {
            print('Location service not enabled...');
            locationEnabled = false;
            rejected = true;
          });
          return;
        }
        print('Location service enabled...');
        locationEnabled = true;
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (!(_permissionGranted == PermissionStatus.granted ||
            _permissionGranted == PermissionStatus.grantedLimited)) {
          setState(() {
            print('Location permission denied...');
            permissionGranted = false;
            rejected = true;
          });
          return;
        }
        print('Location permission granted...');
        permissionGranted = true;
      }

      locationData = await location.getLocation();
      await uploadLocation(locationData!);
      updateFlag = true;
      setState(() {});
      print(locationData);
    } catch (e) {
      print(e);
    }
  }

  uploadLocation(LocationData locationData) {
    print('Uploading location...');
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'lat': locationData.latitude,
        'long': locationData.longitude,
      });
      print('Location uploaded...');
    } catch (e) {
      print('Uploading failed...');
      print(e);
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    if (!rejected && !updateFlag) {
      getLocation();
    }
    if (updateFlag) {
      updateFlag = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Raw Data',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Text(locationData == null
                      ? 'Loading'
                      : 'Latitude: ' + locationData!.latitude.toString()),
                  Text(locationData == null
                      ? 'Loading'
                      : 'Longtitude: ' + locationData!.longitude.toString()),
                  ElevatedButton(
                    child: Text('Sign Out'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
              if (locationData != null)
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('plocation', isEqualTo: true)
                      .get(),
                  builder: (context, snapshots) {
                    // TODO (( unimportant )) show NOONE NEAR for nothing found
                    if (snapshots.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: snapshots.data!.docs.map(
                          (u) {
                            // Make a user object
                            AppUser e = AppUser(
                              cName: u.data()['cname'],
                              cNumber: int.parse(u.data()['cnumber']),
                              fullName: u.data()['fullname'],
                              college: u.data()['college'],
                              email: u.data()['email'],
                              intake: int.parse(u.data()['intake']),
                              lat: u.data()['lat'],
                              long: u.data()['long'],
                              pAlways: u.data()['palways'],
                              pLocation: u.data()['plocation'],
                              pMaps: u.data()['pmaps'],
                              pPhone: u.data()['pphone'],
                              phone: u.data()['phone'],
                            );

                            if (e.email ==
                                FirebaseAuth.instance.currentUser!.email) {
                              return SizedBox();
                            }
                            // Get distance in metres
                            var distanceD = calculateDistance(
                                    locationData!.latitude,
                                    locationData!.longitude,
                                    e.lat,
                                    e.long) *
                                1000;
                            double distance = 0;
                            int distanceInt = 0;
                            bool isKm = false;

                            if (distanceD < 10) {
                              distanceInt = distanceD.toInt();
                            } else {
                              distance = distanceD.roundToDouble() -
                                  distanceD.roundToDouble() % 10;
                              if (distance > 1000) {
                                distance /= 1000;
                                distance =
                                    double.parse(distance.toStringAsFixed(2));
                                isKm = true;
                              }
                              if (!isKm) {
                                distanceInt = distance.round();
                              }
                            }

                            return Container(
                              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Name: ' + e.fullName,
                                      ),
                                      Text(
                                        'Latitude: ' + e.lat.toString(),
                                      ),
                                      Text(
                                        'Longtitude: ' + e.long.toString(),
                                      ),
                                      Text(
                                        (isKm
                                                ? distance.toString()
                                                : distanceInt.toString()) +
                                            (isKm ? 'km' : 'm'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    }
                    return SizedBox();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
