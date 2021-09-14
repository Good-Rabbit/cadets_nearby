import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/contact_card.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactSubPage extends StatefulWidget {
  const ContactSubPage({Key? key}) : super(key: key);

  @override
  _ContactSubPageState createState() => _ContactSubPageState();
}

class _ContactSubPageState extends State<ContactSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Contacts',
              style: TextStyle(fontSize: 20.0),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: HomeSetterPage.store
                  .collection('users')
                  .where('contact', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  if (snapshots.data!.docs.isEmpty) {
                    return Expanded(child: Center(child: noContacts(context)));
                  } else {
                    return Expanded(
                      child: ListView(
                        children: snapshots.data!.docs.map((u) {
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
                            margin:
                                const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: ContactCard(e: e),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }
                return const Expanded(child: Center(child: Loading()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget noContacts(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.no_cell,
          size: 70.0,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          "No contacts",
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
