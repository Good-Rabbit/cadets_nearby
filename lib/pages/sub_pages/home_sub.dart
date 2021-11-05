import 'dart:developer' as dev;

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/data/menu_item.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/ad_card.dart';
import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/pages/ui_elements/filter_range.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/pages/ui_elements/nearby_card.dart';
import 'package:cadets_nearby/services/ad_service.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/sign_out.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeSubPage extends StatefulWidget {
  const HomeSubPage({
    Key? key,
  }) : super(key: key);

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage>
    with AutomaticKeepAliveClientMixin {
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

  String college = 'Select college';

  double min = 0;
  double max = 15;
  int divisions = 3;
  RangeValues range = const RangeValues(0, 15);

  int shown = 0;

  TextEditingController intakeTextController = TextEditingController();

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
        dev.log(e.toString());
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
      // context.read<MainUser>().setLat = locationData.latitude!;
      // context.read<MainUser>().setLong = locationData.longitude!;
      // context.read<MainUser>().user!.sector = sector;
      FlutterBackgroundService().sendData({
        'action': 'setAsForeground',
        'latitude': locationData.latitude!,
        'id': context.read<MainUser>().user!.id,
        // 'longitude': locationData.longitude!,
        'sector': sector,
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  @override
  void dispose() {
    intakeTextController.dispose();
    super.dispose();
  }

  bool onceCheck = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // if (context.read<MainUser>().user!.premium) {
    //   max = 15;
    // }

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

    context.read<GlobalNotifications>().initialize();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return;
      },
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/account');
            },
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: ProfilePicture(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        UserNameRow(),
                        Quote(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/notifications');
                      },
                      icon: const NotificationIndicator(),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                    child: PopupMenuButton<MenuItem>(
                      onSelected: (e) {
                        switch (e) {
                          case MenuItems.itemAccount:
                            Navigator.of(context).pushNamed('/account');
                            break;
                          case MenuItems.itemAbout:
                            Navigator.of(context).pushNamed('/about');
                            break;
                          case MenuItems.itemSignOut:
                            signOut();
                            break;
                          case MenuItems.itemRateUs:
                            launchURL(context.read<Data>().rateLink);
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        ...MenuItems.first.map(buildItem),
                        const PopupMenuDivider(height: 10),
                        ...MenuItems.second.map(buildItem),
                      ],
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
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
                    backgroundColor: Colors.orange[50],
                    avatar: Icon(
                      Icons.circle,
                      color: accuracyColor,
                    ),
                    label: const Text('Accuracy'),
                  ),
                ),
            ],
          ),
          if (locationData != null && !context.read<MainUser>().user!.premium)
            Container(
              margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
              child: AdCard(
                ad: AdService.createBannerAd()..load(),
              ),
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
                      child: ListView(
                        children: snapshots.data!.docs.map(
                          (u) {
                            counter++;
                            bool dontShow = false;
                            // Make a user object
                            final AppUser e = AppUser(
                              id: u.data()['id'] as String,
                              cName: u.data()['cname'] as String,
                              cNumber: int.parse(u.data()['cnumber'] as String),
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
                            } else if (timeDiff.inDays > 30) {
                              dontShow = true;
                            }

                            // * Distance in km
                            var distanceD = calculateDistance(
                                locationData!.latitude!,
                                locationData!.longitude!,
                                e.lat,
                                e.long);

                            // * Range Check
                            if (distanceD > range.end ||
                                distanceD < range.start) {
                              dontShow = true;
                            }
                            // * College Check
                            if (college != filterColleges.elementAt(0)) {
                              if (e.college != college) {
                                dontShow = true;
                              }
                            }
                            // * Intake Check
                            if (intakeTextController.text != '') {
                              if (e.intake !=
                                  int.parse(intakeTextController.text)) {
                                dontShow = true;
                              }
                            }

                            if (!dontShow) shown++;

                            if (counter == snapshots.data!.docs.length) {
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
                              margin:
                                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 5.0),
                              child: NearbyCard(
                                  e: e,
                                  isKm: isKm,
                                  distanceKm: distanceKm,
                                  distanceM: distanceM),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                        children: [
                          noOneNearby(),
                        ],
                      ),
                    );
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
    return showBottomSheetWith([
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
      if (max < 15)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                final bool ready = AdService.isRewardedAdReady;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            ready ? 'Watch ad?' : 'Sorry, no ad available'),
                        actions: [
                          if (ready)
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                AdService.rewardedAd.show(
                                    onUserEarnedReward: (ad, item) {
                                  setState(() {
                                    max = 15;
                                    Future.delayed(const Duration(seconds: 10))
                                        .then((value) {
                                      setState(() {
                                        range = const RangeValues(0, 5);
                                        max = 5;
                                      });
                                    });
                                  });
                                });
                              },
                              child: const Text('Watch ad'),
                            ),
                          if (ready)
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          if (!ready)
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Unlock range'),
            ),
          ],
        ),
      const Text(
        'By College',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        width: 500,
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: Icon(
                Icons.house,
              ),
            ),
          ),
          value: college,
          isDense: true,
          onChanged: (value) {
            setState(() {
              college = value! as String;
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
      const Text(
        'By Intake',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        width: 500,
        child: TextFormField(
          controller: intakeTextController,
          cursorColor: Colors.grey[800],
          decoration: const InputDecoration(
            hintText: 'Intake Year',
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
      )
    ], context);
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

  @override
  bool get wantKeepAlive => true;

  PopupMenuEntry<MenuItem> buildItem(MenuItem e) {
    return PopupMenuItem<MenuItem>(
        value: e,
        child: Row(
          children: [
            e.icon,
            const SizedBox(width: 12),
            Text(e.name),
          ],
        ));
  }
}

class Quote extends StatelessWidget {
  const Quote({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.watch<Data>().quote ?? '',
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: context.watch<MainUser>().user!.photoUrl == ''
            ? Image.asset(
                'assets/images/user.png',
                fit: BoxFit.cover,
              )
            : Image.network(
                context.watch<MainUser>().user!.photoUrl,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
      ),
    );
  }
}

class UserNameRow extends StatelessWidget {
  const UserNameRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.watch<MainUser>().user!.cName,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        if (context.watch<MainUser>().user!.verified != 'yes')
          const Icon(
            Icons.info_rounded,
            size: 15,
            color: Colors.redAccent,
          ),
        if (context.watch<MainUser>().user!.celeb)
          const Icon(
            Icons.verified,
            size: 15,
            color: Colors.green,
          ),
      ],
    );
  }
}

class NotificationIndicator extends StatelessWidget {
  const NotificationIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(context.watch<GlobalNotifications>().hasUnread
        ? Icons.notifications_active
        : Icons.notifications_rounded);
  }
}
