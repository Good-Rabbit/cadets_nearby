import 'package:cadets_nearby/pages/uiElements/verificationSteps.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSubPage extends StatefulWidget {
  AccountSubPage({Key? key}) : super(key: key);

  @override
  _AccountSubPageState createState() => _AccountSubPageState();
}

class _AccountSubPageState extends State<AccountSubPage>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController cNumberTextController = TextEditingController();
  TextEditingController cNameTextController = TextEditingController();
  TextEditingController intakeTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController fbTextController = TextEditingController();
  TextEditingController instaTextController = TextEditingController();
  TextEditingController profTextController = TextEditingController();
  TextEditingController placeTextController = TextEditingController();

  bool locationAccess = true;
  bool phoneAccess = false;
  bool useRegularEmail = false;

  bool inProgress = false;

  String college = 'Pick your college';

  List<String> colleges = [
    'Pick your college',
    'MGCC',
    'JGCC',
    'FGCC',
    'SCC',
    'CCC',
    'PCC',
    'RCC',
    'JCC',
    'FCC',
    'CCR',
    'MCC',
  ];

  bool disabled = false;
  bool once = false;

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
    profTextController.dispose();
    placeTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    resetEdits();
    super.initState();
  }

  bool editingEnabled = false;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return null;
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 40.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Stack(
                            children: [
                              HomeSetterPage.mainUser!.photoUrl == ''
                                  ? Image.asset(
                                      'assets/images/user.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      HomeSetterPage.mainUser!.photoUrl,
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
                                      Navigator.of(context)
                                          .pushNamed('/dpchange');
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        //Enable Account Editing
                        setState(() {
                          editingEnabled = !editingEnabled;
                          if (editingEnabled == false) {
                            resetEdits();
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 20.0,
                        child: Icon(editingEnabled ? Icons.cancel : Icons.edit),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        HomeSetterPage.mainUser!.fullName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      if (HomeSetterPage.mainUser!.verified != 'yes')
                        Icon(
                          Icons.info_rounded,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                      if (HomeSetterPage.mainUser!.celeb)
                        Icon(
                          Icons.verified,
                          size: 20,
                          color: Colors.green,
                        ),
                      if (!HomeSetterPage.auth.currentUser!.emailVerified)
                        InkWell(
                          onTap: () {
                            if (!disabled) {
                              if (!once) {
                                once = true;
                              }
                              HomeSetterPage.auth.currentUser!
                                  .sendEmailVerification()
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('E-mail sent')));
                                setState(() {
                                  disabled = true;
                                });
                                Future.delayed(Duration(minutes: 1))
                                    .then((value) {
                                  setState(() {
                                    disabled = false;
                                  });
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Wait 1 minutes before trying again')));
                            }
                          },
                          child: Text(
                            once ? ' - Resend e-mail ' : ' - Verify e-mail ',
                            style: TextStyle(
                              color: disabled ? Colors.grey[800] : Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (HomeSetterPage.mainUser!.premium)
                  Center(
                    child: Text(
                      'Premium User',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        HomeSetterPage.mainUser!.cName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        HomeSetterPage.mainUser!.cNumber.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (!HomeSetterPage.auth.currentUser!.emailVerified ||
                        HomeSetterPage.mainUser!.verified != 'yes')
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
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
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: ListView(
                        controller: controller,
                        children: [
                          VerificationSteps(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
                          },
                          icon: Icon(Icons.verified_user),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          label: Text('Verification'),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: fullNameTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Full Name*',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.account_box_rounded),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              if (fullNameTextController.text !=
                                  HomeSetterPage.mainUser!.fullName)
                                hasChanged = true;
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
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: cNameTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Cadet Name* -e.g. Rashid',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.perm_identity_rounded),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              if (cNameTextController.text !=
                                  HomeSetterPage.mainUser!.cName)
                                hasChanged = true;
                            });
                          },
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
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: cNumberTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Cadet Number*',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.book),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              if (cNumberTextController.text !=
                                  HomeSetterPage.mainUser!.cNumber.toString())
                                hasChanged = true;
                            });
                          },
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
                      child: Container(
                        width: 500,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.house,
                              ),
                            ),
                          ),
                          value: college,
                          isDense: true,
                          onChanged: !editingEnabled
                              ? null
                              : (value) {
                                  setState(() {
                                    college = value! as String;
                                    if (college !=
                                        HomeSetterPage.mainUser!.college)
                                      hasChanged = true;
                                  });
                                },
                          items: colleges.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (college == 'Pick your college') {
                              return 'Please pick your college';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: intakeTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Intake Year*',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.date_range),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) {
                            setState(() {
                              if (intakeTextController.text !=
                                  HomeSetterPage.mainUser!.intake.toString())
                                hasChanged = true;
                            });
                          },
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
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: profTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Profession',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.work),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (profTextController.text !=
                                  HomeSetterPage.mainUser!.profession
                                      .toString()) hasChanged = true;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: placeTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Workplace',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.location_city),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (placeTextController.text !=
                                  HomeSetterPage.mainUser!.workplace.toString())
                                hasChanged = true;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
                      child: Text(
                        'Contact Info',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: emailTextController,
                          enabled: !useRegularEmail && editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Contact E-mail*',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  Icons.alternate_email,
                                )),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              if (emailTextController.text !=
                                  HomeSetterPage.mainUser!.email)
                                hasChanged = true;
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
                            var temp = val;
                            List a = temp.split('@');
                            if (a.length > 2)
                              return 'Please provide a valid E-mail';
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: CheckboxListTile(
                          value: useRegularEmail,
                          title: Text(
                            'Use login e-mail',
                            maxLines: 2,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: !editingEnabled
                              ? null
                              : (value) {
                                  setState(() {
                                    if (value!) {
                                      emailTextController.text = HomeSetterPage
                                          .auth.currentUser!.email!;
                                    } else {
                                      emailTextController.text = '';
                                    }
                                    useRegularEmail = value;
                                    if (emailTextController.text !=
                                        HomeSetterPage.mainUser!.email)
                                      hasChanged = true;
                                  });
                                }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: fbTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'username e.g. "rashid.hr"',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                FontAwesomeIcons.facebook,
                                color:
                                    !editingEnabled ? Colors.grey : Colors.blue,
                              ),
                            ),
                            prefix: Text(
                              '/',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    !editingEnabled ? Colors.grey : Colors.blue,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (instaTextController.text !=
                                  HomeSetterPage.mainUser!.instaUrl)
                                hasChanged = true;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: instaTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'username e.g. "harun.xt"',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: !editingEnabled
                                    ? Colors.grey
                                    : Colors.deepOrange,
                              ),
                            ),
                            prefix: Text(
                              '/',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: !editingEnabled
                                    ? Colors.grey
                                    : Colors.deepOrange,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (instaTextController.text !=
                                  HomeSetterPage.mainUser!.instaUrl)
                                hasChanged = true;
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: phoneTextController,
                          enabled: editingEnabled,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'Phone',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(Icons.phone),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: editingEnabled ? Colors.black : Colors.grey,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            if (phoneTextController.text == '') {
                              phoneAccess = false;
                            }
                            setState(() {
                              if (phoneTextController.text !=
                                  HomeSetterPage.mainUser!.phone)
                                hasChanged = true;
                            });
                          },
                          validator: (val) {
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      width: 500,
                      child: CheckboxListTile(
                          value: phoneAccess,
                          title: Text('Make phone number public'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: (phoneTextController.text == '' ||
                                  !editingEnabled)
                              ? null
                              : (value) {
                                  setState(() {
                                    phoneAccess = value!;
                                    if (phoneAccess !=
                                        HomeSetterPage.mainUser!.pPhone)
                                      hasChanged = true;
                                  });
                                }),
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: CheckboxListTile(
                          value: !locationAccess,
                          title: Text(
                            'Hide my exact location (Still show me in nearby result)',
                            maxLines: 2,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: !editingEnabled
                              ? null
                              : (value) {
                                  setState(() {
                                    locationAccess = !value!;
                                    if (locationAccess !=
                                        HomeSetterPage.mainUser!.pLocation)
                                      hasChanged = true;
                                  });
                                }),
                    ),
                  ],
                ),
                Container(
                  width: 500,
                  margin: EdgeInsets.fromLTRB(100, 20, 100, 0),
                  child: ElevatedButton.icon(
                    onPressed: !(editingEnabled && hasChanged && !inProgress)
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
                              var parts =
                                  fullNameTextController.text.split(' ');
                              for (var each in parts) {
                                first = each[0];
                                first = first.toUpperCase();
                                fullName += first + each.substring(1) + ' ';
                              }
                              fullName = fullName.trim();
                              try {
                                await HomeSetterPage.auth.currentUser!
                                    .updateDisplayName('Saim Ul Islam');
                                await HomeSetterPage.store
                                    .collection('users')
                                    .doc(HomeSetterPage.auth.currentUser!.uid)
                                    .update({
                                  'fullname': fullName,
                                  'intake': intakeTextController.text,
                                  'college': college,
                                  'cname': cName,
                                  'cnumber': cNumberTextController.text,
                                  'phone': phoneTextController.text,
                                  'email':
                                      HomeSetterPage.auth.currentUser!.email,
                                  'pphone': phoneAccess,
                                  'plocation': locationAccess,
                                  'fburl': fbTextController.text,
                                  'instaurl': instaTextController.text,
                                  'workplace': placeTextController.text,
                                  'profession': profTextController.text,
                                });
                                HomeSetterPage.mainUser = AppUser(
                                  id: HomeSetterPage.mainUser!.id,
                                  cName: cName,
                                  cNumber:
                                      int.parse(cNumberTextController.text),
                                  fullName: fullName,
                                  college: college,
                                  email: emailTextController.text,
                                  intake: int.parse(intakeTextController.text),
                                  pAlways: HomeSetterPage.mainUser!.pAlways,
                                  pLocation: locationAccess,
                                  pMaps: HomeSetterPage.mainUser!.pMaps,
                                  pPhone: phoneAccess,
                                  photoUrl: HomeSetterPage
                                          .auth.currentUser!.photoURL ??
                                      '',
                                  phone: phoneTextController.text,
                                  fbUrl: fbTextController.text,
                                  instaUrl: instaTextController.text,
                                  timeStamp: HomeSetterPage.mainUser!.timeStamp,
                                  premium: HomeSetterPage.mainUser!.premium,
                                  verified: HomeSetterPage.mainUser!.verified,
                                  celeb: HomeSetterPage.mainUser!.celeb,
                                  bountyHead:
                                      HomeSetterPage.mainUser!.bountyHead,
                                  bountyHunter:
                                      HomeSetterPage.mainUser!.bountyHunter,
                                  workplace: placeTextController.text,
                                  profession: profTextController.text,
                                  manualDp: HomeSetterPage.mainUser!.manualDp,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Account settings updated',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print(e);
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
                    icon: Icon(Icons.save),
                    label: Text('Save Changes'),
                  ),
                ),
                Container(
                  width: 500,
                  margin: EdgeInsets.fromLTRB(100, 15, 100, 15),
                  child: ElevatedButton(
                    child: Text('Sign Out'),
                    onPressed: () {
                      HomeSetterPage.auth.signOut();
                    },
                  ),
                ),
                SizedBox(
                  height: 120.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetEdits() {
    locationAccess = HomeSetterPage.mainUser!.pLocation;
    phoneAccess = HomeSetterPage.mainUser!.pPhone;
    fullNameTextController.text = HomeSetterPage.mainUser!.fullName;
    cNameTextController.text = HomeSetterPage.mainUser!.cName;
    cNumberTextController.text = HomeSetterPage.mainUser!.cNumber.toString();
    intakeTextController.text = HomeSetterPage.mainUser!.intake.toString();
    phoneTextController.text = HomeSetterPage.mainUser!.phone;
    emailTextController.text = HomeSetterPage.mainUser!.email;
    fbTextController.text = HomeSetterPage.mainUser!.fbUrl;
    instaTextController.text = HomeSetterPage.mainUser!.instaUrl;
    profTextController.text = HomeSetterPage.mainUser!.profession;
    placeTextController.text = HomeSetterPage.mainUser!.workplace;
    college = HomeSetterPage.mainUser!.college;
    useRegularEmail = HomeSetterPage.mainUser!.email ==
        HomeSetterPage.auth.currentUser!.email;
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
