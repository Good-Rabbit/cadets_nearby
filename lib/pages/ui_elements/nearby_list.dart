import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/nearby_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'filter_days.dart';
import 'nearby_card.dart';
import 'no_one_nearby.dart';

class NearbyList extends StatefulWidget {
  const NearbyList({Key? key, required this.docs}) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  @override
  _NearbyListState createState() => _NearbyListState();
}

class _NearbyListState extends State<NearbyList> {
  int shown = 0;
  int counter = 0;

  double min = 0;
  double max = 8;
  int divisions = 4;

  List<AppUser> celebs = [];
  List<AppUser> batchMates = [];
  List<AppUser> collegeMates = [];
  List<AppUser> others = [];

  List<AppUser> all = [];

  @override
  Widget build(BuildContext context) {
    celebs = [];
    batchMates = [];
    collegeMates = [];
    others = [];
    all = [];

    for (var u in widget.docs) {
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
        timeStamp: u.data()['lastonline'] == null
            ? DateTime(2000)
            : DateTime.parse(u.data()['lastonline']),
        premiumTo: u.data()['premiumto'] == null
            ? DateTime.now()
            : DateTime.parse(u.data()['premiumto'] as String),
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
      if (e.celeb) {
        celebs.add(e);
        continue;
      } else if (e.intake == context.read<MainUser>().user!.intake) {
        batchMates.add(e);
        continue;
      } else if (e.college == context.read<MainUser>().user!.college) {
        collegeMates.add(e);
        continue;
      } else {
        others.add(e);
        continue;
      }
    }

    all = [...celebs, ...batchMates, ...collegeMates, ...others];

    shown = 0;
    counter = 0;

    Color accuracyColor = Colors.white;
    if (context.read<LocationStatus>().locationData != null) {
      accuracyColor =
          context.read<LocationStatus>().locationData!.accuracy! <= 40
              ? Colors.green
              : (context.read<LocationStatus>().locationData!.accuracy! <= 100
                  ? Colors.orange
                  : Colors.red);
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: ElevatedButton.icon(
                  onPressed: () {
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
              if (context.read<LocationStatus>().locationData != null)
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
          Column(
            children: all.map(
              (e) {
                counter++;
                bool dontShow = false;
                Duration timeDiff;
                timeDiff = DateTime.now().difference(e.timeStamp);

                if (e.equals(context.read<MainUser>().user!) &&
                    widget.docs.length == 1) {
                  return noOneNearby(context);
                } else if (e.equals(context.read<MainUser>().user!)) {
                  dontShow = true;
                }

                // * Distance in meters
                var distanceD = calculateDistance(
                        context.read<LocationStatus>().locationData!.latitude!,
                        context.read<LocationStatus>().locationData!.longitude!,
                        e.lat,
                        e.long) *
                    1000;

                // * Range Check
                if (distanceD >
                    int.parse(
                        context.read<Nearby>().range.substring(0, 4).trim())) {
                  dontShow = true;
                }
                // * College Check
                if (context.read<Nearby>().collegeName !=
                    filterColleges.elementAt(0)) {
                  if (e.college != context.read<Nearby>().collegeName) {
                    dontShow = true;
                  }
                }
                // * Intake Check
                if (context.read<Nearby>().intakeTextController.text != '') {
                  if (e.intake != context.read<Nearby>().intakeYear) {
                    dontShow = true;
                  }
                }
                // * Time Check
                if (timeDiff.inDays > context.read<Nearby>().days) {
                  dontShow = true;
                }

                if (!dontShow) shown++;

                if (counter == widget.docs.length) {
                  counter = 0;
                  if (shown == 0) {
                    return noOneNearby(context);
                  }
                }

                if (dontShow) {
                  return const SizedBox();
                }

                // * Distance in meter
                // * Distance in meter rounded to tens
                int distanceM = distanceD.toInt();
                bool isKm = false;
                double distanceKm = 0;
                if (distanceM > 1000) {
                  isKm = true;
                  distanceKm = distanceD.roundToDouble() -
                      distanceD.roundToDouble() % 10;
                  distanceKm /= 1000;
                  distanceKm = double.parse(distanceKm.toStringAsFixed(2));
                } else if (distanceM >= 10) {
                  distanceM = distanceM - distanceM % 10;
                }

                return Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 5.0),
                  child: NearbyCard(
                      e: e,
                      isKm: isKm,
                      distanceKm: distanceKm,
                      distanceM: distanceM),
                );
              },
            ).toList(),
          ),
        ]),
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
                    'By Last Active Time',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  FilterSlider(
                    value: context.read<Nearby>().days,
                    unit: 'Days ago',
                    min: 1.0,
                    max: 30.0,
                    divisions: 10,
                    onChanged: (value) {
                      // setState(() {
                      context.read<Nearby>().days = value.toInt();
                      // });
                    },
                  ),
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
                          // setState(() {
                          context.read<Nearby>().college = value! as String;
                          // });
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
                        // setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done')),
            ],
          );
        });
  }
}
