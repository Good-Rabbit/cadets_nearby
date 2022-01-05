import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/filter_days.dart';
import 'package:cadets_nearby/pages/ui_elements/filter_range.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/pages/ui_elements/nearby_card.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/nearby_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class NearbyList extends StatefulWidget {
  const NearbyList({Key? key}) : super(key: key);

  @override
  _NearbyListState createState() => _NearbyListState();
}

class _NearbyListState extends State<NearbyList> {
  bool warningGiven = false;
  bool locationEnabled = true;
  bool permissionGranted = true;
  bool rejected = false;
  bool updateFlag = false;
  bool disabled = false;
  bool loadingComplete = false;

  bool timeout = false;

  LocationData? locationData;

  double latMax = 0;
  double latMin = 0;

  double min = 0;
  double max = 15;
  int divisions = 3;

  int shown = 0;

  @override
  void initState() {
    super.initState();
  }

  void calculateMinMax(BuildContext context) {
    latMax = Provider.of<MainUser>(context, listen: false).user!.lat + 0.138;
    latMin = Provider.of<MainUser>(context, listen: false).user!.lat - 0.138;
  }

  Future<void> getLocation() async {
    if (!timeout) {
      timeout = true;

      try {
        final Location location = Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;

        _serviceEnabled = await location.serviceEnabled();
        locationEnabled = _serviceEnabled;
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            setState(() {
              locationEnabled = false;
              rejected = true;
            });
            return;
          }
          locationEnabled = true;
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (!(_permissionGranted == PermissionStatus.granted ||
              _permissionGranted == PermissionStatus.grantedLimited)) {
            setState(() {
              permissionGranted = false;
              rejected = true;
            });
            return;
          }
          permissionGranted = true;
        }

        locationData = await location.getLocation();
        //Calculate minimum and maximum for other distances
        // ignore: use_build_context_synchronously
        calculateMinMax(context);
        uploadLocation(locationData!);
        updateFlag = true;
        loadingComplete = true;
        setState(() {});
      } catch (e) {
        log(e.toString());
      }
      Future.delayed(const Duration(minutes: 1)).then((value) {
        timeout = false;
      });
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

      FlutterBackgroundService().sendData({
        'action': 'setAsForeground',
        'latitude': locationData.latitude!,
        'id': context.read<MainUser>().user!.id,
        // 'longitude': locationData.longitude!,
        'sector': sector,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  bool onceCheck = true;

  @override
  Widget build(BuildContext context) {
    if (!rejected && !updateFlag && onceCheck) {
      getLocation();
    }
    if (updateFlag) {
      updateFlag = false;
    }

    if (context.read<MainUser>().user!.verified == 'no' && !warningGiven) {
      warningGiven = true;
      Future.delayed(const Duration(seconds: 5)).then((value) {
        Navigator.of(context).pushNamed('/verification');
      });
    }

    int counter = 0;
    Color accuracyColor = Colors.white;
    if (locationData != null) {
      accuracyColor = locationData!.accuracy! <= 40
          ? Colors.green
          : (locationData!.accuracy! <= 100 ? Colors.orange : Colors.red);
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: ElevatedButton.icon(
                  onPressed: !loadingComplete
                      ? null
                      : () {
                          showFilter(context);
                        },
                  icon: const Icon(Icons.filter_alt_rounded),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.deepOrange),
                  ),
                  label: const Text('Filter'),
                ),
              ),
              if (locationData != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Chip(
                    avatar: Icon(
                      Icons.circle,
                      color: accuracyColor,
                    ),
                    label: const Text('Accuracy'),
                  ),
                ),
            ],
          ),
          if (locationData != null &&
              !(rejected || !locationEnabled || !permissionGranted))
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: HomeSetterPage.store
                  .collection('users')
                  .where('lat', isLessThan: latMax, isGreaterThan: latMin)
                  .where('sector', whereIn: [
                context.read<MainUser>().user!.sector + 3,
                context.read<MainUser>().user!.sector + 2,
                context.read<MainUser>().user!.sector + 1,
                context.read<MainUser>().user!.sector,
                context.read<MainUser>().user!.sector - 1,
                context.read<MainUser>().user!.sector - 2,
                context.read<MainUser>().user!.sector - 3,
              ]).snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  shown = 0;
                  if (snapshots.data!.docs.length != 1 &&
                      snapshots.data!.docs.isNotEmpty) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: snapshots.data!.docs.map(
                            (u) {
                              counter++;
                              bool dontShow = false;
                              // Make a user object
                              final AppUser e = AppUser(
                                id: u.data()['id'] as String,
                                cName: u.data()['cname'] as String,
                                cNumber:
                                    int.parse(u.data()['cnumber'] as String),
                                fullName: u.data()['fullname'] as String,
                                college: u.data()['college'] as String,
                                email: u.data()['email'] as String,
                                intake: int.parse(u.data()['intake'] as String),
                                lat: u.data()['lat'] as double,
                                long: u.data()['long'] as double,
                                timeStamp: DateTime.parse(
                                    u.data()['lastonline'] as String),
                                premiumTo: u.data()['premiumto'] == null
                                    ? DateTime.now()
                                    : DateTime.parse(
                                        u.data()['premiumto'] as String),
                                photoUrl: u.data()['photourl'] as String,
                                pAlways: u.data()['palways'] as bool,
                                pLocation: u.data()['plocation'] as bool,
                                pMaps: u.data()['pmaps'] as bool,
                                pPhone: u.data()['pphone'] as bool,
                                phone: u.data()['phone'] as String,
                                premium: u.data()['premium'] as bool,
                                verified: u.data()['verified'] as String,
                                fbUrl: u.data()['fburl'] as String,
                                instaUrl: u.data()['instaurl'] as String,
                                celeb: u.data()['celeb'] as bool,
                                treatHead: u.data()['treathead'] as bool,
                                treatHunter: u.data()['treathunter'] as bool,
                                designation: u.data()['designation'] as String,
                                profession: u.data()['profession'] as String,
                                manualDp: u.data()['manualdp'] as bool,
                                treatCount: u.data()['treatcount'] as int,
                                sector: u.data()['sector'] as int,
                                address: u.data()['address'] as String,
                                contact: u.data()['contact'] as bool,
                                coupons: u.data()['coupons'] as int,
                              );

                              Duration timeDiff;
                              timeDiff = DateTime.now().difference(e.timeStamp);

                              if (e.equals(context.read<MainUser>().user!) &&
                                  snapshots.data!.docs.length == 1) {
                                return noOneNearby();
                              } else if (e
                                  .equals(context.read<MainUser>().user!)) {
                                dontShow = true;
                              }

                              // * Distance in km
                              var distanceD = calculateDistance(
                                  locationData!.latitude!,
                                  locationData!.longitude!,
                                  e.lat,
                                  e.long);

                              // * Range Check
                              if (distanceD >
                                      context.read<Nearby>().range.end ||
                                  distanceD <
                                      context.read<Nearby>().range.start) {
                                dontShow = true;
                              }
                              // * College Check
                              if (context.read<Nearby>().collegeName !=
                                  filterColleges.elementAt(0)) {
                                if (e.college !=
                                    context.read<Nearby>().collegeName) {
                                  dontShow = true;
                                }
                              }
                              // * Intake Check
                              if (context
                                      .read<Nearby>()
                                      .intakeTextController
                                      .text !=
                                  '') {
                                if (e.intake !=
                                    context.read<Nearby>().intakeYear) {
                                  dontShow = true;
                                }
                              }
                              // * Time Check
                              if (timeDiff.inDays >
                                  context.read<Nearby>().days) {
                                dontShow = true;
                              }

                              if (!dontShow) shown++;

                              if (counter == snapshots.data!.docs.length) {
                                counter = 0;
                                if (shown == 0) {
                                  return noOneNearby();
                                }
                              }

                              if (dontShow) {
                                return const SizedBox();
                              }

                              // * Distance in meter
                              distanceD *= 1000;
                              // * Distance in meter rounded to tens
                              int distanceM = distanceD.toInt();
                              bool isKm = false;
                              double distanceKm = 0;
                              if (distanceM > 1000) {
                                isKm = true;
                                distanceKm = distanceD.roundToDouble() -
                                    distanceD.roundToDouble() % 10;
                                distanceKm /= 1000;
                                distanceKm =
                                    double.parse(distanceKm.toStringAsFixed(2));
                              } else if (distanceM >= 10) {
                                distanceM = distanceM - distanceM % 10;
                              }

                              return Container(
                                margin: const EdgeInsets.fromLTRB(
                                    10.0, 0, 10.0, 5.0),
                                child: NearbyCard(
                                    e: e,
                                    isKm: isKm,
                                    distanceKm: distanceKm,
                                    distanceM: distanceM),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  } else {
                    return noOneNearby();
                  }
                }
                return const Expanded(child: Loading());
              },
            ),
          if (rejected || !locationEnabled || !permissionGranted)
            Expanded(child: locationDisabled()),
          if (locationData == null && permissionGranted && locationEnabled)
            const Expanded(child: Loading()),
        ],
      ),
    );
  }

  Future<dynamic> showFilter(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            title: const Text('Filter'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'By Distance',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  FilterRange(
                    range: context.read<Nearby>().range,
                    divisions: divisions,
                    min: min.floorToDouble(),
                    max: max.ceilToDouble(),
                    onChanged: (value) {
                      setState(() {
                        context.read<Nearby>().range = value;
                      });
                    },
                  ),
                  const SavePrefsCheck(),
                  const Text(
                    'By Last Active Time',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  FilterDays(
                    value: context.read<Nearby>().days,
                    min: 1.0,
                    max: 30.0,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        context.read<Nearby>().days = value.toInt();
                      });
                    },
                  ),

                  //! Filter Range With Ads
                  // if (max < 15)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       ElevatedButton.icon(
                  //         onPressed: () {
                  //           final bool ready = AdService.isRewardedAdReady;
                  //           showDialog(
                  //               context: context,
                  //               builder: (context) {
                  //                 return AlertDialog(
                  //                   title: Text(ready
                  //                       ? 'Watch ad?'
                  //                       : 'Sorry, no ad available'),
                  //                   actions: [
                  //                     if (ready)
                  //                       TextButton(
                  //                         onPressed: () {
                  //                           Navigator.of(context).pop();
                  //                           Navigator.of(context).pop();
                  //                           AdService.rewardedAd.show(
                  //                               onUserEarnedReward: (ad, item) {
                  //                             setState(() {
                  //                               max = 15;
                  //                               Future.delayed(const Duration(
                  //                                       seconds: 10))
                  //                                   .then((value) {
                  //                                 setState(() {
                  //                                   range =
                  //                                       const RangeValues(0, 5);
                  //                                   max = 5;
                  //                                 });
                  //                               });
                  //                             });
                  //                           });
                  //                         },
                  //                         child: const Text('Watch ad'),
                  //                       ),
                  //                     if (ready)
                  //                       TextButton(
                  //                         onPressed: () {
                  //                           Navigator.of(context).pop();
                  //                         },
                  //                         child: const Text('Cancel'),
                  //                       ),
                  //                     if (!ready)
                  //                       TextButton(
                  //                         onPressed: () {
                  //                           Navigator.of(context).pop();
                  //                         },
                  //                         child: const Text('Ok'),
                  //                       ),
                  //                   ],
                  //                 );
                  //               });
                  //         },
                  //         icon: const Icon(Icons.play_arrow),
                  //         label: const Text('Unlock range'),
                  //       ),
                  //     ],
                  //   ),

                  const Text(
                    'By College',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    width: 500,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).bottomAppBarColor,
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              Icons.house,
                            ),
                          ),
                        ),
                        value: context.read<Nearby>().college,
                        isDense: true,
                        onChanged: (value) {
                          setState(() {
                            context.read<Nearby>().college = value! as String;
                          });
                        },
                        items: filterColleges.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const Text(
                    'By Intake',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    width: 500,
                    child: TextFormField(
                      controller: context.read<Nearby>().intakeTextController,
                      cursorColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        hintText: 'Joining Year',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Icon(Icons.date_range),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done')),
            ],
          );
        });
  }

  Widget noOneNearby() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *3/4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.no_accounts,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'No one nearby',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget locationDisabled() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_disabled,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Location Disabled',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class SavePrefsCheck extends StatelessWidget {
  const SavePrefsCheck({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: context.watch<Nearby>().saveFilter,
      title: const Text('Save Range Preferences'),
      onChanged: (value) {
        context.read<Nearby>().saveFilter = value!;
      },
    );
  }
}
