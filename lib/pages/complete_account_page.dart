import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/data/data.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/nearby_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteAccountPage extends StatefulWidget {
  const CompleteAccountPage({
    Key? key,
    // required this.loggedInNotifier
  }) : super(key: key);

  // final Function loggedInNotifier;

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
  bool useRegularEmail = true;
  bool inProgress = false;
  bool terms = false;
  bool privacy = false;

  String college = 'Pick your college*';
  String profession = 'Student';

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
    formKey.currentState == null ? true : formKey.currentState!.dispose();
    super.dispose();
  }

  Future<void> getLocation() async {
    try {
      await context.read<LocationStatus>().getLocation();

      final GeoCode geoCode = GeoCode(apiKey: geoCodeApiKey);
      if (context.read<LocationStatus>().locationData != null) {
        final Address address = await geoCode.reverseGeocoding(
          latitude: context.read<LocationStatus>().locationData!.latitude!,
          longitude: context.read<LocationStatus>().locationData!.longitude!,
        );
        addressTextController.text =
            '${address.streetAddress!}, ${address.region!}';
      }
      // setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    emailTextController.text = HomeSetterPage.auth.currentUser!.email!;
    super.initState();
    getLocation();
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: cNameTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Cadet Name* e.g. Rashid',
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: cNumberTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Cadet Number* e.g. 2129',
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.book),
                              ),
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Cadet Number is required';
                              }
                              if (!isInt(val)) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
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
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: intakeTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Joining Year* e.g. 2016',
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.date_range),
                              ),
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Joining year is required';
                              }
                              if (!isInt(val)) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Theme.of(context).bottomAppBarColor,
                            ),
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
                                  profession = value! as String;
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
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: designationTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Designation at institute',
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.location_city_rounded),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: addressTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Address*',
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(Icons.location_pin),
                              ),
                            ),
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Address is required';
                              }
                              return null;
                            },
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: CheckboxListTile(
                              value: useRegularEmail,
                              title: const Text(
                                'Use login e-mail',
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          'P.S. The username and regular name are not the same thing for facebook and instagram. If you are unsure about the username, please leave the following 2 fields blank.',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          'For "https://fb.com/cadetsnearby.bd" -',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: fbTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'username e.g. "cadetsnearby.bd"',
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          'For "https://instagr.am/cadetsnearby.bd" -',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: instaTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'username e.g. "cadetsnearby.bd"',
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
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: phoneTextController,
                            cursorColor: Colors.grey[800],
                            decoration: const InputDecoration(
                              hintText: 'Phone e.g +8801*********',
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
                              if (phoneTextController.text.length == 1) {
                                phoneAccess = true;
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: CheckboxListTile(
                              value: phoneAccess,
                              title: const Text('Make phone number public'),
                              subtitle: Text(
                                'Anyone near you can use your phone number',
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
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
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: CheckboxListTile(
                              value: terms,
                              title: Row(
                                children: [
                                  const Text(
                                    'I agree to the ',
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // * Cannot scroll webview in bottom sheet
                                      // showBottomSheetWith([
                                      //   SizedBox(
                                      //     height:
                                      //         MediaQuery.of(context).size.height -
                                      //             100,
                                      //     child: const WebView(
                                      //       initialUrl: 'https://google.com',
                                      //     ),
                                      //   ),
                                      // ], context);
                                      // * Opening external link
                                      launchURL(
                                          context.read<Data>().termsConditions);
                                    },
                                    child: Text(
                                      'terms and conditions',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              onChanged: (value) {
                                setState(() {
                                  terms = value!;
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: CheckboxListTile(
                              value: privacy,
                              title: Row(
                                children: [
                                  const Text(
                                    'I agree to the ',
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // * Cannot scroll webview in bottom sheet
                                      // showBottomSheetWith([
                                      //   SizedBox(
                                      //     height:
                                      //         MediaQuery.of(context).size.height -
                                      //             100,
                                      //     child: const WebView(
                                      //       initialUrl: 'https://google.com',
                                      //     ),
                                      //   ),
                                      // ], context);
                                      // * Opening to external link
                                      launchURL(
                                          context.read<Data>().termsConditions);
                                    },
                                    child: Text(
                                      'privacy policy',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              onChanged: (value) {
                                setState(() {
                                  privacy = value!;
                                });
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 500,
                          child: CheckboxListTile(
                              value: !locationAccess,
                              title: const Text(
                                'Hide my exact location',
                              ),
                              subtitle: Text(
                                'Still show me in nearby result',
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              onChanged: (value) {
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
                                  FocusScope.of(context).unfocus();
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
                                onPressed: (inProgress || !(privacy && terms))
                                    ? null
                                    : () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          inProgress = true;
                                        });
                                        if (formKey.currentState!.validate()) {
                                          prefs.setString(
                                                                  'range',
                                                                  '2000 m');
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Select your default range in meters (you can change it later)'),
                                                  content: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0.0, 10.0, 0.0, 0.0),
                                                    child: SizedBox(
                                                      width: 500,
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          canvasColor: Theme.of(
                                                                  context)
                                                              .bottomAppBarColor,
                                                        ),
                                                        child:
                                                            DropdownButtonFormField(
                                                          hint: const Text(
                                                              'Distance Control'),
                                                          decoration:
                                                              const InputDecoration(
                                                            prefixIcon: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10.0,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Icon(
                                                                Icons
                                                                    .location_pin,
                                                              ),
                                                            ),
                                                          ),
                                                          value: context
                                                              .read<Nearby>()
                                                              .range,
                                                          isDense: true,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              context
                                                                      .read<
                                                                          Nearby>()
                                                                      .range =
                                                                  value!
                                                                      as String;
                                                              prefs.setString(
                                                                  'range',
                                                                  value as String);
                                                            });
                                                          },
                                                          items: nearbyRange
                                                              .map((String
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(value
                                                                  .toString()),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          completionDialog();
                                                        },
                                                        child:
                                                            const Text('Ok.')),
                                                  ],
                                                );
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'Please fill up all the fields.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Okay')),
                                                  ],
                                                );
                                              });
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
      ),
    );
  }

  completionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Is the information correct?'),
            content: const Text(
                'Some of your information cannot be changed later. e.g. Cadet name/number, college, joining year.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No, go back.')),
              TextButton(
                  onPressed: () async {
                    await context.read<LocationStatus>().checkPermissions();
                    await completeAccount();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes.')),
            ],
          );
        });
  }

  Future<void> completeAccount() async {
    String cName = cNameTextController.text;
    String first = cName[0];
    first = first.toUpperCase();
    cName = first + cName.substring(1);

    String fullName = '';
    final parts = fullNameTextController.text.split(' ');
    final StringBuffer fname = StringBuffer();
    for (final each in parts) {
      first = each[0];
      first = first.toUpperCase();
      fname.write('$first${each.substring(1)} ');
    }
    fullName = fname.toString().trim();

    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const SafeArea(child: Text('Updating account info')),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      int sector = 0;
      sector =
          ((context.read<LocationStatus>().locationData!.latitude! - 20.56666) /
                  (0.0181))
              .ceil();
      HomeSetterPage.store
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {
          'id': HomeSetterPage.auth.currentUser!.uid,
          'address': addressTextController.text,
          'contact': false,
          'coupons': (DateTime.now().day > 14 ? 2 : 3),
          'college': college,
          'celeb': false,
          'cname': cName,
          'cnumber': cNumberTextController.text,
          'designation': designationTextController.text,
          'email': emailTextController.text,
          'fullname': fullName,
          'fburl': fbTextController.text,
          'intake': intakeTextController.text,
          'instaurl': instaTextController.text,
          'lastonline': DateTime.now().toString(),
          'lat': context.read<LocationStatus>().locationData == null
              ? 0
              : context.read<LocationStatus>().locationData!.latitude,
          'long': context.read<LocationStatus>().locationData == null
              ? 0
              : context.read<LocationStatus>().locationData!.longitude,
          'manualdp': false,
          'phone': phoneTextController.text,
          'pphone': phoneAccess,
          'plocation': locationAccess,
          'profession': profession,
          'palways': alwaysAccess,
          'pmaps': false,
          'premium': false,
          'photourl': HomeSetterPage.auth.currentUser!.photoURL ?? '',
          'sector': sector,
          'treatcount': 0,
          'treathead': true,
          'treathunter': true,
          'verified': 'no',
        },
      );
    } catch (e) {
      log(e.toString());
    }
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

  bool isInt(String? value) {
    if (value == null) {
      return false;
    }
    final int? number = int.tryParse(value);
    return number != null;
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
