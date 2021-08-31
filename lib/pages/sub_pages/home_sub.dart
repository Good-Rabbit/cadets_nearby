import 'dart:developer' as dev;
import 'dart:math';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/filter_range.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/pages/ui_elements/nearby_card.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeSubPage extends StatefulWidget {
  const HomeSubPage({Key? key, required this.setSelectedIndex})
      : super(key: key);

  final Function setSelectedIndex;

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage>
    with AutomaticKeepAliveClientMixin {
  bool warningGiven = false;
  bool locationEnabled = false;
  bool permissionGranted = false;
  bool rejected = false;
  bool updateFlag = false;
  bool disabled = false;
  bool loadingComplete = false;

  bool locationTimeout = false;
  bool dataFetchTimeout = false;

  List<AppUser> savedUsers = [];

  LocationData? locationData;

  double latMax = 0;
  double latMin = 0;

  double longMax = 0;
  double longMin = 0;

  String? quote;

  double min = 0;
  double max = 15;
  int divisions = 3;
  RangeValues range = const RangeValues(0, 5);

  int shown = 0;

  void calculateMinMax() {
    latMax = (HomeSetterPage.mainUser!.lat) + 0.1;
    latMin = (HomeSetterPage.mainUser!.lat) - 0.1;
    longMax = (HomeSetterPage.mainUser!.long) + 0.1;
    longMin = (HomeSetterPage.mainUser!.long) - 0.1;
  }

  Future<void> getLocation() async {
    if (!locationTimeout) {
      locationTimeout = true;

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
        calculateMinMax();
        uploadLocation(locationData!);
        updateFlag = true;
        loadingComplete = true;
        setState(() {});
      } catch (e) {
        dev.log(e.toString());
      }
      Future.delayed(const Duration(minutes: 1)).then((value) {
        locationTimeout = false;
      });
    }
  }

  void uploadLocation(LocationData locationData) {
    int sector = 0;
    sector = ((locationData.latitude! - 20.56666) / (0.1)).ceil();
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
      HomeSetterPage.mainUser!.lat = locationData.latitude!;
      HomeSetterPage.mainUser!.long = locationData.latitude!;
    } catch (e) {
      dev.log(e.toString());
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const  p = 0.017453292519943295;
    const  c = cos;
    final  a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> getQuote() async {
    final doc = await HomeSetterPage.store.collection('quotes').doc('1').get();
    quote = doc.data()!['quote'] as String;
  }

  Future<void> clearTimeout() async {
    Future.delayed(const Duration(minutes: 1)).then((value) {
      dataFetchTimeout = false;
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

    // TODO enable verification
    if (HomeSetterPage.mainUser!.verified == 'no' && !warningGiven) {
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
        return;
      },
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              widget.setSelectedIndex(2);
            },
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: CircleAvatar(
                      radius: 20.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: HomeSetterPage.mainUser!.photoUrl == ''
                            ? Image.asset(
                                'assets/images/user.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                HomeSetterPage.mainUser!.photoUrl,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              HomeSetterPage.mainUser!.cName,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            if (HomeSetterPage.mainUser!.verified != 'yes')
                              const Icon(
                                Icons.info_rounded,
                                size: 15,
                                color: Colors.redAccent,
                              ),
                            if (HomeSetterPage.mainUser!.celeb)
                              const Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.green,
                              ),
                          ],
                        ),
                        Text(
                          quote ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/notifications');
                      },
                      icon: Icon(
                          context.watch<GlobalNotifications>().hasUnread
                              ? Icons.notifications_active
                              : Icons.notifications_rounded),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(15.0),
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 10, 10),
                                        child: ListView(
                                          controller: controller,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'By Distance',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            FilterRange(
                                              range: range,
                                              divisions: divisions,
                                              min: min.floorToDouble(),
                                              max: max.ceilToDouble(),
                                              onChanged: (value) {
                                                setState(() {
                                                  range = value;
                                                });
                                              },
                                            ),
                                            const Text('By College - TODO'),
                                            const Text('By Intake - TODO'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                  icon: const Icon(Icons.filter_alt),
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Row(
                        children: [
                          const Text(
                            'Accuracy ',
                          ),
                          Icon(
                            Icons.circle,
                            color: accuracyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (locationData != null && !dataFetchTimeout)
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: HomeSetterPage.store
                  .collection('users')
                  //TODO uncomment
                  .where('lat', isLessThan: latMax, isGreaterThan: latMin)
                  .where('sector', whereIn: [
                HomeSetterPage.mainUser!.sector + 1,
                HomeSetterPage.mainUser!.sector,
                HomeSetterPage.mainUser!.sector - 1,
              ]).get(),
              builder: (context, snapshots) {
                dataFetchTimeout = true;
                if (snapshots.hasData) {
                  shown = 0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshots.data!.docs.isEmpty
                        ? [noOneNearby()]
                        : snapshots.data!.docs.map(
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
                                intake:
                                    int.parse(u.data()['intake'] as String),
                                lat: u.data()['lat'] as double,
                                long: u.data()['long'] as double,
                                timeStamp: DateTime.parse(
                                    u.data()['lastonline'] as String),
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
                                designation:
                                    u.data()['designation'] as String,
                                profession: u.data()['profession'] as String,
                                manualDp: u.data()['manualdp'] as bool,
                                treatCount: u.data()['treatcount'] as int,
                                sector: u.data()['sector'] as int,
                                district: u.data()['district'] as String,
                              );

                              Duration timeDiff;
                              timeDiff =
                                  DateTime.now().difference(e.timeStamp);

                              if (e.equals(HomeSetterPage.mainUser!) &&
                                  snapshots.data!.docs.length == 1) {
                                return noOneNearby();
                              } else if (e.equals(HomeSetterPage.mainUser!)) {
                                dontShow = true;
                              } else if (timeDiff.inDays > 30) {
                                dontShow = true;
                              }

                              //Distance in km
                              var distanceD = calculateDistance(
                                  locationData!.latitude!,
                                  locationData!.longitude!,
                                  e.lat,
                                  e.long);

                              // Range Check
                              if (distanceD > range.end ||
                                  distanceD < range.start) {
                                dontShow = true;
                              }

                              if (!dontShow) shown++;

                              if (counter == snapshots.data!.docs.length) {
                                clearTimeout();
                                if (shown == 0) {
                                  return noOneNearby();
                                }
                              }

                              if (dontShow) {
                                return const SizedBox();
                              }
                              bool contains = false;
                              for (final user in savedUsers) {
                                if (user.id == e.id) {
                                  contains = true;
                                  break;
                                }
                              }
                              if (!contains && !dontShow) {
                                savedUsers.add(e);
                              }

                              //This is kinda fuzzy, I'll optimize it later
                              // ------------
                              //Distance in meter
                              distanceD *= 1000;
                              //Distance in meter rounded to tens
                              double distanceKm = distanceD.roundToDouble() -
                                  distanceD.roundToDouble() % 10;
                              distanceKm /= 1000;
                              distanceKm =
                                  double.parse(distanceKm.toStringAsFixed(2));
                              int distanceM = distanceD.toInt();
                              bool isKm = false;

                              if (distanceM >= 10) {
                                distanceM = distanceM - distanceM % 10;
                              }
                              if (distanceM > 1000) {
                                isKm = true;
                              }
                              // -------------
                              return Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: NearbyCard(
                                    e: e,
                                    isKm: isKm,
                                    distanceKm: distanceKm,
                                    distanceM: distanceM),
                              );
                            },
                          ).toList(),
                  );
                }
                return const Loading();
              },
            ),
          if (locationData != null && dataFetchTimeout)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: savedUsers.isEmpty
                  ? [noOneNearby()]
                  : savedUsers.map((e) {
                      bool dontShow = false;
                      counter++;
                      if (e.equals(HomeSetterPage.mainUser!) &&
                          savedUsers.length == 1) {
                        return noOneNearby();
                      } else if (e.equals(HomeSetterPage.mainUser!)) {
                        dontShow = true;
                      }
                      // Get distance in metres
                      var distanceD = calculateDistance(
                          locationData!.latitude!,
                          locationData!.longitude!,
                          e.lat,
                          e.long);

                      // Range Check
                      if (distanceD > range.end || distanceD < range.start) {
                        dontShow = true;
                      }

                      if (!dontShow) shown++;

                      if (counter == savedUsers.length) {
                        if (shown == 0) {
                          return noOneNearby();
                        }
                      }

                      if (dontShow) {
                        return const SizedBox();
                      }

                      //This is kinda fuzzy, I'll optimize it later
                      // ------------
                      //Distance in meter
                      distanceD *= 1000;
                      //Distance in meter rounded to tens
                      double distanceKm = distanceD.roundToDouble() -
                          distanceD.roundToDouble() % 10;
                      distanceKm /= 1000;
                      distanceKm =
                          double.parse(distanceKm.toStringAsFixed(2));
                      int distanceM = distanceD.toInt();
                      bool isKm = false;

                      if (distanceM >= 10) {
                        distanceM = distanceM - distanceM % 10;
                      }
                      if (distanceM > 1000) {
                        isKm = true;
                      }
                      // -------------

                      return Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: NearbyCard(
                            e: e,
                            isKm: isKm,
                            distanceKm: distanceKm,
                            distanceM: distanceM),
                      );
                    }).toList(),
            ),
          if (locationData == null) const Loading(),
          const SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Widget noOneNearby() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_accounts,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            "No one nearby",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
