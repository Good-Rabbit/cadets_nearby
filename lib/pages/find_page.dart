import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/no_one_found.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'ui_elements/contact_card.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  TextEditingController fullNameTextController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool searched = false;

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.headline6,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        title: const Text('Find someone'),
        elevation: 0,
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: SizedBox(
                width: 500,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    search();
                  },
                  controller: fullNameTextController,
                  cursorColor: Colors.grey[800],
                  decoration: const InputDecoration(
                    hintText: 'Cadet Name*',
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: Icon(Icons.account_box_rounded),
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
          ),
          const SizedBox(height: 10.0),
          ElevatedButton.icon(
            onPressed: () {
              search();
            },
            icon: Icon(Icons.search_rounded,
                color: Theme.of(context).primaryColor),
            label: Text(
              'Find',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withAlpha(60),
              ),
            ),
          ),
          if (searched)
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: HomeSetterPage.store
                  .collection('users')
                  .where('cname', isEqualTo: name)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Expanded(child: Center(child: noOneFound(context)));
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: snapshot.data!.docs.map((u) {
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
                            return Container(
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 5.0),
                              child: ContactCard(e: e),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
        ],
      ),
    );
  }

  void search() {
    if (key.currentState!.validate()) {
      name = fullNameTextController.text;
      name = name[0].toUpperCase() + name.substring(1);
      setState(() {
        searched = true;
      });
    }
  }
}
