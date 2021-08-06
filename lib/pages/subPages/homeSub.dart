import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:readiew/pages/homeSetter.dart';
import 'package:readiew/pages/uiElements/loading.dart';
import 'package:readiew/pages/uiElements/nearbyCard.dart';
import 'package:readiew/services/user.dart';

class HomeSubPage extends StatefulWidget {
  HomeSubPage({Key? key}) : super(key: key);

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage>
    with AutomaticKeepAliveClientMixin {
  bool locationEnabled = false;
  bool permissionGranted = false;
  bool rejected = false;
  bool updateFlag = false;
  LocationData? locationData;

  double latMax = 0;
  double latMin = 0;

  double longMax = 0;
  double longMin = 0;

  calculateMinMax() {
    latMax = (HomeSetterPage.mainUser!.lat ?? 0) + 0.1;
    latMin = (HomeSetterPage.mainUser!.lat ?? 0) - 0.1;
    longMax = (HomeSetterPage.mainUser!.long ?? 0) + 0.1;
    longMin = (HomeSetterPage.mainUser!.long ?? 0) - 0.1;
    // print(latMin.toString() +
    //     ' ' +
    //     latMax.toString() +
    //     ' ' +
    //     longMin.toString() +
    //     ' ' +
    //     longMax.toString());
  }

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
      //Calculate minimum and maximum for other distances
      calculateMinMax();
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
    String timeStamp = DateTime.now().toString();
    try {
      HomeSetterPage.store
          .collection('users')
          .doc(HomeSetterPage.auth.currentUser!.uid)
          .update({
        'lat': locationData.latitude,
        'long': locationData.longitude,
        'lastonline': timeStamp,
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
    super.build(context);
    if (!rejected && !updateFlag) {
      getLocation();
    }
    if (updateFlag) {
      updateFlag = false;
    }
    return Container(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: HomeSetterPage.mainUser!.photoUrl! == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            HomeSetterPage.mainUser!.photoUrl!,
                            width: 80,
                            height: 80,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          HomeSetterPage.mainUser!.cName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(' ' + HomeSetterPage.mainUser!.cNumber.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    HomeSetterPage.auth.signOut();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (locationData != null)
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: HomeSetterPage.store
                  .collection('users')
                  //TODO Uncomment later
                  // .where('long', isLessThan: longMax, isGreaterThan: longMin)
                  .get(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshots.data!.docs.length == 0
                        ? [noOneNearby()]
                        : snapshots.data!.docs.map(
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
                                timeStamp: u.data()['lastonline'] == null
                                    ? null
                                    : DateTime.parse(u.data()['lastonline']),
                                photoUrl: u.data()['photourl'],
                                pAlways: u.data()['palways'],
                                pLocation: u.data()['plocation'],
                                pMaps: u.data()['pmaps'],
                                pPhone: u.data()['pphone'],
                                phone: u.data()['phone'],
                                premium: u.data()['premium'],
                                verified: u.data()['verified'],
                                celeb: u.data()['celeb'],
                              );

                              if (e.equals(HomeSetterPage.mainUser!) &&
                                  snapshots.data!.docs.length == 1) {
                                return noOneNearby();
                              } else if (e.equals(HomeSetterPage.mainUser!)) {
                                return SizedBox();
                              }
                              print(e);
                              //TODO Uncomment later
                              // else if (!((e.lat ?? 0) < latMax &&
                              //     (e.lat ?? 0) > latMin)) {
                              //   return SizedBox();
                              // }
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
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: NearbyCard(
                                    e: e,
                                    isKm: isKm,
                                    distance: distance,
                                    distanceInt: distanceInt),
                              );
                            },
                          ).toList(),
                  );
                }
                return Loading();
              },
            ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Container noOneNearby() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.no_accounts,
              size: 70.0,
            ),
            Text(
              "No one nearby",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
