import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/data/snackbar_mixin.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/pages/ui_elements/verification_steps.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/nearby_provider.dart';
import 'package:cadets_nearby/services/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage>
    with AutomaticKeepAliveClientMixin, AsyncSnackbar {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameTextController = TextEditingController();
  String? cNumber;
  String? cName;
  String? intake;
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController fbTextController = TextEditingController();
  TextEditingController instaTextController = TextEditingController();
  TextEditingController designationTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

  bool locationAccess = true;
  bool phoneAccess = false;
  bool useLoginEmail = false;

  bool inProgress = false;
  bool hasChanged = false;

  String? college;
  String profession = 'Doctor';

  SharedPreferences? prefs;

  @override
  void dispose() {
    fullNameTextController.dispose();
    phoneTextController.dispose();
    emailTextController.dispose();
    fbTextController.dispose();
    instaTextController.dispose();
    designationTextController.dispose();
    addressTextController.dispose();
    super.dispose();
  }

  loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    loadPrefs();
    resetEdits();
    super.initState();
  }

  bool editingEnabled = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          backgroundColor: Colors.transparent,
          actions: [
            if ((editingEnabled && hasChanged && !inProgress))
              showSaveButton(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (editingEnabled) {
                      resetEdits();
                    }
                    editingEnabled = !editingEnabled;
                  });
                },
                icon: editingEnabled
                    ? const Icon(Icons.cancel)
                    : const Icon(Icons.edit),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pop();
                signOut();
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      children: [
                        if (context.watch<MainUser>().user!.photoUrl == '')
                          Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.cover,
                          )
                        else
                          Image.network(
                            context.watch<MainUser>().user!.photoUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        if (editingEnabled)
                          Container(
                            color: Colors.black.withOpacity(0.65),
                            width: 80,
                            height: 80,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/dpchange');
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<MainUser>().user!.fullName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    if (context.watch<MainUser>().user!.verified != 'yes')
                      const Icon(
                        Icons.info_rounded,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                    if (context.watch<MainUser>().user!.celeb)
                      const Icon(
                        Icons.verified,
                        size: 20,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<MainUser>().user!.cName,
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      context.watch<MainUser>().user!.cNumber.toString(),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    child: FilledButton.icon(
                      onPressed: !(!HomeSetterPage
                                  .auth.currentUser!.emailVerified ||
                              context.read<MainUser>().user!.verified != 'yes')
                          ? null
                          : () {
                              showBottomSheetWith(
                                  const [VerificationSteps()], context);
                            },
                      icon: const Icon(Icons.verified_user),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            (!HomeSetterPage.auth.currentUser!.emailVerified ||
                                    context.watch<MainUser>().user!.verified !=
                                        'yes')
                                ? Colors.red
                                : Colors.green),
                      ),
                      label: Text((!HomeSetterPage
                                  .auth.currentUser!.emailVerified ||
                              context.watch<MainUser>().user!.verified != 'yes')
                          ? 'Verification'
                          : 'Verified'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: SizedBox(
                      width: 500,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor:
                              Theme.of(context).bottomAppBarTheme.color,
                        ),
                        child: DropdownButtonFormField(
                          hint: const Text('Distance Control'),
                          decoration: InputDecoration(
                            suffixIcon: const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.location_pin,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ),
                          value: context.read<Nearby>().range,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              String val = value.toString();
                              if (context.read<Nearby>().range != val) {
                                context.read<Nearby>().range = val;
                                prefs!.setString('range', val);
                              }
                            });
                          },
                          items: nearbyRange.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: fullNameTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Full Name*',
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.account_box_rounded),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
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
                        initialValue: cName,
                        enabled: false,
                        decoration: const InputDecoration(
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.perm_identity_rounded),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        initialValue: cNumber,
                        enabled: false,
                        decoration: const InputDecoration(
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.book),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        initialValue: college,
                        enabled: false,
                        decoration: const InputDecoration(
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.house),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        initialValue: intake,
                        enabled: false,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Joining Year*',
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.date_range),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
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
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor:
                              Theme.of(context).bottomAppBarTheme.color,
                        ),
                        child: DropdownButtonFormField(
                          iconDisabledColor: Colors.grey[800],
                          hint: const Text('Profession'),
                          icon: const Icon(
                            Icons.work,
                          ),
                          value: profession,
                          isDense: true,
                          onChanged: !editingEnabled
                              ? null
                              : (value) {
                                  setState(() {
                                    profession = value! as String;
                                    checkChanged();
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
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        enabled: editingEnabled,
                        controller: designationTextController,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Designation at institute',
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.location_city_rounded),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
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
                        enabled: editingEnabled,
                        controller: addressTextController,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Address*',
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.location_pin),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
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
                        enabled: !useLoginEmail && editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Contact E-mail*',
                          suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.alternate_email,
                              )),
                        ),
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
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
                  Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: CheckboxListTile(
                        value: useLoginEmail,
                        title: const Text(
                          'Use login e-mail',
                          maxLines: 2,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  if (value!) {
                                    emailTextController.text =
                                        HomeSetterPage.auth.currentUser!.email!;
                                    checkChanged();
                                  } else {
                                    emailTextController.text = '';
                                    checkChanged();
                                  }
                                  useLoginEmail = value;
                                });
                              }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: fbTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          labelText: 'fb_username',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color:
                                  !editingEnabled ? Colors.grey : Colors.blue,
                            ),
                          ),
                          prefix: Text(
                            'fb.com/',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  !editingEnabled ? Colors.grey : Colors.blue,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: instaTextController,
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: InputDecoration(
                          labelText: 'insta_username',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              color: !editingEnabled
                                  ? Colors.grey
                                  : Colors.deepOrange,
                            ),
                          ),
                          prefix: Text(
                            'instagr.am/',
                            style: TextStyle(
                              fontSize: 20,
                              color: !editingEnabled
                                  ? Colors.grey
                                  : Colors.deepOrange,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkChanged();
                          });
                        },
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
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
                        enabled: editingEnabled,
                        cursorColor: Colors.grey[800],
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Icon(Icons.phone),
                          ),
                        ),
                        style: TextStyle(
                          color: editingEnabled
                              ? Theme.of(context).textTheme.titleMedium!.color
                              : Colors.grey,
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          if (phoneTextController.text == '') {
                            phoneAccess = false;
                          }
                          setState(() {
                            checkChanged();
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    width: 500,
                    child: CheckboxListTile(
                        value: phoneAccess,
                        title: const Text('Make phone number public'),
                        subtitle: Text(
                          'Anyone near you can use your phone number',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        onChanged:
                            (phoneTextController.text == '' || !editingEnabled)
                                ? null
                                : (value) {
                                    setState(() {
                                      phoneAccess = value!;
                                      checkChanged();
                                    });
                                  }),
                  ),
                  Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: CheckboxListTile(
                        value: !locationAccess,
                        title: const Text(
                          'Hide my exact location',
                        ),
                        subtitle: Text(
                          'Still show me in nearby result',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        onChanged: !editingEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  locationAccess = !value!;
                                  checkChanged();
                                });
                              }),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton showSaveButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        FocusScope.of(context).unfocus();
        setState(() {
          inProgress = true;
        });
        if (formKey.currentState!.validate()) {
          String cName = this.cName ?? '';
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
            await HomeSetterPage.auth.currentUser!
                .updateDisplayName('Saim Ul Islam');
            await HomeSetterPage.store
                .collection('users')
                .doc(HomeSetterPage.auth.currentUser!.uid)
                .update({
              'fullname': fullName,
              'phone': phoneTextController.text,
              'email': emailTextController.text,
              'pphone': phoneAccess,
              'plocation': locationAccess,
              'fburl': fbTextController.text,
              'instaurl': instaTextController.text,
              'designation': designationTextController.text,
              'profession': profession,
              'address': addressTextController.text,
            });
            showSnackbar('Account settings updated');
          } catch (e) {
            log(e.toString());
          }
          setState(() {
            hasChanged = false;
            editingEnabled = false;
            inProgress = false;
          });
        } else {
          setState(() {
            inProgress = false;
          });
        }
      },
      icon: const Icon(Icons.save),
      label: const Text('Save'),
    );
  }

  bool isInt(String? value) {
    if (value == null) {
      return false;
    }
    final int? number = int.tryParse(value);
    return number != null;
  }

  void resetEdits() {
    locationAccess = context.read<MainUser>().user!.pLocation;
    phoneAccess = context.read<MainUser>().user!.pPhone;
    fullNameTextController.text = context.read<MainUser>().user!.fullName;
    cName = context.read<MainUser>().user!.cName;
    cNumber = context.read<MainUser>().user!.cNumber.toString();
    intake = context.read<MainUser>().user!.intake.toString();
    phoneTextController.text = context.read<MainUser>().user!.phone;
    emailTextController.text = context.read<MainUser>().user!.email;
    fbTextController.text = context.read<MainUser>().user!.fbUrl;
    instaTextController.text = context.read<MainUser>().user!.instaUrl;
    profession = context.read<MainUser>().user!.profession;
    designationTextController.text = context.read<MainUser>().user!.designation;
    addressTextController.text = context.read<MainUser>().user!.address;
    college = context.read<MainUser>().user!.college;
    useLoginEmail = context.read<MainUser>().user!.email ==
        HomeSetterPage.auth.currentUser!.email;
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
  }

  bool checkChanged() {
    hasChanged = false;
    if (fullNameTextController.text !=
        context.read<MainUser>().user!.fullName) {
      hasChanged = true;
    }
    if (phoneTextController.text != context.read<MainUser>().user!.phone) {
      hasChanged = true;
    }
    if (emailTextController.text != context.read<MainUser>().user!.email) {
      hasChanged = true;
    }
    if (fbTextController.text != context.read<MainUser>().user!.fbUrl) {
      hasChanged = true;
    }
    if (instaTextController.text != context.read<MainUser>().user!.instaUrl) {
      hasChanged = true;
    }
    if (designationTextController.text !=
        context.read<MainUser>().user!.designation) {
      hasChanged = true;
    }
    if (addressTextController.text != context.read<MainUser>().user!.address) {
      hasChanged = true;
    }
    if (locationAccess != context.read<MainUser>().user!.pLocation) {
      hasChanged = true;
    }
    if (phoneAccess != context.read<MainUser>().user!.pPhone) {
      hasChanged = true;
    }
    if (profession != context.read<MainUser>().user!.profession) {
      hasChanged = true;
    }

    return hasChanged;
  }

  @override
  bool get wantKeepAlive => true;
}
