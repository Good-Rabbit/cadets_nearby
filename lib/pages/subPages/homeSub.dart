import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/pages/uiElements/filterRange.dart';
import 'package:cadets_nearby/pages/uiElements/loading.dart';
import 'package:cadets_nearby/pages/uiElements/nearbyCard.dart';
import 'package:cadets_nearby/services/user.dart';

class HomeSubPage extends StatefulWidget {
  HomeSubPage({Key? key, required this.setSelectedIndex}) : super(key: key);

  final Function setSelectedIndex;

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage>
    with AutomaticKeepAliveClientMixin {
  bool locationEnabled = false;
  bool permissionGranted = false;
  bool rejected = false;
  bool updateFlag = false;
  bool disabled = false;
  bool loadingComplete = false;

  bool locationTimeout = false;

  List<AppUser> savedUsers = [];

  LocationData? locationData;

  double latMax = 0;
  double latMin = 0;

  double longMax = 0;
  double longMin = 0;

  String? quote;

  RangeValues range = RangeValues(0, 10);
  double min = 0;
  double max = 10;

  calculateMinMax() {
    latMax = (HomeSetterPage.mainUser!.lat) + 0.1;
    latMin = (HomeSetterPage.mainUser!.lat) - 0.1;
    longMax = (HomeSetterPage.mainUser!.long) + 0.1;
    longMin = (HomeSetterPage.mainUser!.long) - 0.1;
    // print(latMin.toString() +
    //     ' ' +
    //     latMax.toString() +
    //     ' ' +
    //     longMin.toString() +
    //     ' ' +
    //     longMax.toString());
  }

  getLocation() async {
    if (!locationTimeout) {
      locationTimeout = true;
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
        loadingComplete = true;
        setState(() {});
        print(locationData);
      } catch (e) {
        print(e);
      }
      Future.delayed(Duration(minutes: 1)).then((value) {
        locationTimeout = false;
      });
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

  getQuote() async {
    print('here');
    var doc = await HomeSetterPage.store.collection('quotes').doc('1').get();
    quote = doc.data()!['quote'] ?? 'Demo Quote For Now';
  }

  clearSaved() async {
    Future.delayed(Duration(minutes: 1)).then((value) {
      savedUsers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (quote == null) {
      getQuote();
    }
    if (!rejected && !updateFlag) {
      getLocation();
    }
    if (updateFlag) {
      updateFlag = false;
    }

    int counter = 0;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return null;
      },
      child: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  widget.setSelectedIndex(4);
                },
                child: Card(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: CircleAvatar(
                          radius: 20.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: HomeSetterPage.mainUser!.photoUrl == ''
                                ? Image.asset('assets/images/user.png')
                                : Image.network(
                                    HomeSetterPage.mainUser!.photoUrl,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  HomeSetterPage.mainUser!.cName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // if (!HomeSetterPage
                                //     .auth.currentUser!.emailVerified)
                                //   GestureDetector(
                                //     onTap: disabled
                                //         ? null
                                //         : () {
                                //             HomeSetterPage.auth.currentUser!
                                //                 .sendEmailVerification()
                                //                 .then((value) {
                                //               ScaffoldMessenger.of(context)
                                //                   .showSnackBar(SnackBar(
                                //                       content:
                                //                           Text('E-mail sent')));
                                //               setState(() {
                                //                 disabled = true;
                                //               });
                                //             });
                                //           },
                                //     child: Text(
                                //       ' - Verify e-mail ',
                                //       style: TextStyle(
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ),
                                if (!HomeSetterPage.mainUser!.verified)
                                  Icon(
                                    Icons.info_rounded,
                                    size: 15,
                                    color: Colors.redAccent,
                                  ),
                                if (HomeSetterPage.mainUser!.celeb)
                                  Icon(
                                    Icons.verified,
                                    size: 15,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                            Text(
                              quote ?? '',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: !loadingComplete
                        ? null
                        : () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => Navigator.of(context).pop(),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: DraggableScrollableSheet(
                                        initialChildSize: 0.7,
                                        maxChildSize: 0.9,
                                        minChildSize: 0.5,
                                        builder: (_, controller) => Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange[50],
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 10, 10),
                                          child: ListView(
                                            controller: controller,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'By Distance',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              FilterRange(
                                                range: range,
                                                min: min.floorToDouble(),
                                                max: max.ceilToDouble(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    range = value;
                                                  });
                                                },
                                              ),
                                              Text('By College - TODO'),
                                              Text('By Intake - TODO'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                    icon: Icon(Icons.filter_alt),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.deepOrange),
                    ),
                    label: Text('Filter'),
                  ),
                ),
              ],
            ),
            if (locationData != null && savedUsers.isEmpty)
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: HomeSetterPage.store
                    .collection('users')
                    //TODO Uncomment later
                    // .where('long', isLessThan: longMax, isGreaterThan: longMin)
                    .get(),
                builder: (context, snapshots) {
                  print('Getting Users...');
                  if (snapshots.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: snapshots.data!.docs.length == 0
                          ? [noOneNearby()]
                          : snapshots.data!.docs.map(
                              (u) {
                                // Make a user object
                                AppUser e = AppUser(
                                  id: u.data()['id'],
                                  cName: u.data()['cname'],
                                  cNumber: int.parse(u.data()['cnumber']),
                                  fullName: u.data()['fullname'],
                                  college: u.data()['college'],
                                  email: u.data()['email'],
                                  intake: int.parse(u.data()['intake']),
                                  lat: u.data()['lat'],
                                  long: u.data()['long'],
                                  timeStamp:
                                      DateTime.parse(u.data()['lastonline']),
                                  photoUrl: u.data()['photourl'],
                                  pAlways: u.data()['palways'],
                                  pLocation: u.data()['plocation'],
                                  pMaps: u.data()['pmaps'],
                                  pPhone: u.data()['pphone'],
                                  phone: u.data()['phone'],
                                  premium: u.data()['premium'],
                                  verified: u.data()['verified'],
                                  fbUrl: u.data()['fburl'],
                                  instaUrl: u.data()['instaurl'],
                                  celeb: u.data()['celeb'],
                                  bountyHead: u.data()['bountyhead'],
                                  bountyHunter: u.data()['bountyhunter'],
                                );

                                Duration timeDiff;
                                timeDiff =
                                    DateTime.now().difference(e.timeStamp);

                                if (e.equals(HomeSetterPage.mainUser!) &&
                                    snapshots.data!.docs.length == 1) {
                                  return noOneNearby();
                                } else if (e.equals(HomeSetterPage.mainUser!)) {
                                  return SizedBox();
                                } else if (timeDiff.inDays > 30) {
                                  return SizedBox();
                                }
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
                                    e.long);
                                counter++;
                                max = distanceD > max ? distanceD : max;
                                savedUsers.add(e);
                                if (counter ==
                                    (snapshots.data!.docs.length - 1)) {
                                  range = RangeValues(min, max.ceilToDouble());
                                  clearSaved();
                                }
                                distanceD *= 1000;
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
                                    distance = double.parse(
                                        distance.toStringAsFixed(2));
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
            if (locationData != null && savedUsers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: savedUsers.map((e) {
                  if (e.equals(HomeSetterPage.mainUser!) &&
                      savedUsers.length == 1) {
                    return noOneNearby();
                  } else if (e.equals(HomeSetterPage.mainUser!)) {
                    return SizedBox();
                  }
                  //TODO Uncomment later
                  // else if (!((e.lat ?? 0) < latMax &&
                  //     (e.lat ?? 0) > latMin)) {
                  //   return SizedBox();
                  // }
                  // Get distance in metres
                  var distanceD = calculateDistance(locationData!.latitude,
                      locationData!.longitude, e.lat, e.long);
                  if (distanceD > range.end || distanceD < range.start) {
                    return SizedBox();
                  }
                  distanceD *= 1000;
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
                      distance = double.parse(distance.toStringAsFixed(2));
                      isKm = true;
                    }
                    if (!isKm) {
                      distanceInt = distance.round();
                    }
                  }

                  return Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: NearbyCard(
                        e: e,
                        isKm: isKm,
                        distance: distance,
                        distanceInt: distanceInt),
                  );
                }).toList(),
              ),
            if (locationData == null) Loading(),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Container noOneNearby() {
    return Container(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
