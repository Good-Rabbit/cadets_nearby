import 'dart:developer';

import 'package:cadets_nearby/data/data.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:cadets_nearby/data/app_data.dart';

class CompleteAccountPage extends StatefulWidget {
  const CompleteAccountPage({required this.loggedInNotifier});

  final Function loggedInNotifier;

  @override
  _CompleteAccountPageState createState() => _CompleteAccountPageState();
}

class _CompleteAccountPageState extends State<CompleteAccountPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController cNumberTextController = TextEditingController();
  TextEditingController cNameTextController = TextEditingController();
  TextEditingController intakeTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController fbTextController = TextEditingController();
  TextEditingController instaTextController = TextEditingController();
  TextEditingController designationTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

  bool locationAccess = true;
  bool alwaysAccess = false;
  bool phoneAccess = false;
  bool useRegularEmail = false;
  bool inProgress = false;

  String college = 'Pick your college*';
  String profession = 'Student';

  LocationData? locationData;

  @override
  void dispose() {
    fullNameTextController.dispose();
    cNumberTextController.dispose();
    cNameTextController.dispose();
    intakeTextController.dispose();
    phoneTextController.dispose();
    emailTextController.dispose();
    fbTextController.dispose();
    instaTextController.dispose();
    designationTextController.dispose();
    addressTextController.dispose();
    super.dispose();
  }

  Future<void> getLocations() async {
    try {
      final Location location = Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (!(_permissionGranted == PermissionStatus.granted ||
            _permissionGranted == PermissionStatus.grantedLimited)) {
          return;
        }
      }

      locationData = await location.getLocation();

      final GeoCode geoCode = GeoCode(apiKey: geoCodeApiKey);
      if (locationData != null) {
        final Address address = await geoCode.reverseGeocoding(
          latitude: locationData!.latitude!,
          longitude: locationData!.longitude!,
        );
        addressTextController.text = '${address.streetAddress!}, ${address.region!}';
      }
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        delLogout(context);
        return false;
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(
                        'Complete Account',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 40),
                      child: Text(
                        'Please provide us with the necessary information to set up your account.',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: fullNameTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Full Name*',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.account_box_rounded),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: cNameTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Cadet Name* -e.g. Rashid',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.perm_identity_rounded),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Cadet name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: cNumberTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Cadet Number*',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.book),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Cadet Number is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
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
                          items: colleges.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (college == 'Pick your college*') {
                              return 'Please pick your college';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: intakeTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Intake Year*',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.date_range),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Intake year is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: DropdownButtonFormField(
                          hint: const Text('Profession'),
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.work,
                              ),
                            ),
                          ),
                          value: profession,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              college = value! as String;
                            });
                          },
                          items: professions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: designationTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Designation at institue',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.location_city),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: addressTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Address',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.location_pin),
                            ),
                          ),
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
                      child: Text(
                        'Contact Info',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: emailTextController,
                          enabled: !useRegularEmail,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Contact E-mail*',
                            prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  Icons.alternate_email,
                                )),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Contact e-mail is required';
                            }
                            if (!val.contains('@') ||
                                !val.contains('.') ||
                                val.endsWith('@') ||
                                val.endsWith('.')) {
                              return 'Please provide a valid E-mail';
                            }
                            final temp = val;
                            final List a = temp.split('@');
                            if (a.length > 2) {
                              return 'Please provide a valid E-mail';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: CheckboxListTile(
                            value: useRegularEmail,
                            title: const Text(
                              'Use login e-mail',
                              maxLines: 2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  emailTextController.text =
                                      HomeSetterPage.auth.currentUser!.email!;
                                } else {
                                  emailTextController.text = '';
                                }
                                useRegularEmail = value;
                              });
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: fbTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'username e.g. "rashid.hr"',
                            prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.blue,
                                )),
                            prefix: Text(
                              '/',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: instaTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'username e.g. "harun.xt"',
                            prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.deepOrange,
                                )),
                            prefix: Text(
                              '/',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: phoneTextController,
                          cursorColor: Colors.grey[800],
                          decoration: const InputDecoration(
                            hintText: 'Phone',
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.phone),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            if (phoneTextController.text == '') {
                              phoneAccess = false;
                            }
                            setState(() {});
                          },
                          validator: (val) {
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: CheckboxListTile(
                            value: phoneAccess,
                            title: const Text('Make phone number public'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            activeColor: Colors.black,
                            onChanged: phoneTextController.text == ''
                                ? null
                                : (value) {
                                    setState(() {
                                      phoneAccess = value!;
                                    });
                                  }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: CheckboxListTile(
                            value: !locationAccess,
                            title: const Text(
                              'Hide my exact location (Still show me in nearby result)',
                              maxLines: 2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            activeColor: Colors.black,
                            onChanged: (value) {
                              getLocationPermission();
                              setState(() {
                                locationAccess = !value!;
                              });
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                      child: SizedBox(
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                delLogout(context);
                              },
                              label: const Text('Cancel'),
                              icon: const Icon(
                                Icons.arrow_left_rounded,
                                size: 20,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: inProgress
                                  ? null
                                  : () async {
                                      setState(() {
                                        inProgress = true;
                                      });
                                      if (formKey.currentState!.validate()) {
                                        String cName = cNameTextController.text;
                                        String first = cName[0];
                                        first = first.toUpperCase();
                                        cName = first + cName.substring(1);

                                        String fullName = '';
                                        final parts = fullNameTextController
                                            .text
                                            .split(' ');
                                        final StringBuffer fname =
                                            StringBuffer();
                                        for (final each in parts) {
                                          first = each[0];
                                          first = first.toUpperCase();
                                          fname.write(
                                              '$first${each.substring(1)} ');
                                        }
                                        fullName = fname.toString().trim();

                                        try {
                                          await FirebaseAuth
                                              .instance.currentUser!
                                              .updateDisplayName(fullName);
                                          await HomeSetterPage.store
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .set(
                                            {
                                              'id': HomeSetterPage
                                                  .auth.currentUser!.uid,
                                              'fullname': fullName,
                                              'intake':
                                                  intakeTextController.text,
                                              'college': college,
                                              'cname': cName,
                                              'cnumber':
                                                  cNumberTextController.text,
                                              'phone': phoneTextController.text,
                                              'fburl': fbTextController.text,
                                              'instaurl':
                                                  instaTextController.text,
                                              'email': HomeSetterPage
                                                  .auth.currentUser!.email,
                                              'pphone': phoneAccess,
                                              'plocation': locationAccess,
                                              'palways': alwaysAccess,
                                              'pmaps': false,
                                              'premium': false,
                                              'verified': 'no',
                                              'photourl': HomeSetterPage.auth
                                                      .currentUser!.photoURL ??
                                                  '',
                                              'celeb': false,
                                              'treatcount': 0,
                                              'treathead': true,
                                              'treathunter': true,
                                              'profession': profession,
                                              'designation':
                                                  designationTextController
                                                      .text,
                                              'address': addressTextController.text,
                                              'manualdp': false,
                                              'sector': 0,
                                              'contact':false,
                                            },
                                          );
                                          // ignore: use_build_context_synchronously
                                          context.read<MainUser>().user =
                                              AppUser(
                                            id: HomeSetterPage
                                                .auth.currentUser!.uid,
                                            cName: cName,
                                            cNumber: int.parse(
                                                cNumberTextController.text),
                                            fullName: fullName,
                                            college: college,
                                            email: FirebaseAuth
                                                .instance.currentUser!.email!,
                                            intake: int.parse(
                                                intakeTextController.text),
                                            pAlways: alwaysAccess,
                                            pLocation: locationAccess,
                                            pPhone: phoneAccess,
                                            photoUrl: HomeSetterPage.auth
                                                    .currentUser!.photoURL ??
                                                '',
                                            phone: phoneTextController.text,
                                            premium: false,
                                            verified: 'no',
                                            timeStamp: DateTime.now(),
                                            celeb: false,
                                            treatHead: true,
                                            fbUrl: fbTextController.text,
                                            instaUrl: instaTextController.text,
                                            treatHunter: true,
                                            treatCount: 0,
                                            designation:
                                                designationTextController.text,
                                            profession: profession,
                                            address: addressTextController.text,
                                            manualDp: false,
                                            sector: 0,
                                            contact: false,
                                          );
                                          widget.loggedInNotifier();
                                        } catch (e) {
                                          log(e.toString());
                                        }
                                      }
                                      setState(() {
                                        inProgress = false;
                                      });
                                    },
                              label: const Text('Continue'),
                              icon: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> delLogout(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Your account will be deleted.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/cancel');
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  Future<void> getLocationPermission() async {
    try {
      final Location location = Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          setState(() {});
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (!(_permissionGranted == PermissionStatus.granted ||
            _permissionGranted == PermissionStatus.grantedLimited)) {
          setState(() {});
          return;
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
