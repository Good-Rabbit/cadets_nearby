import 'dart:developer';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'ui_elements/contact_card.dart';

class SupportDetailsPage extends StatefulWidget {
  const SupportDetailsPage({Key? key}) : super(key: key);

  @override
  _SupportDetailsPageState createState() => _SupportDetailsPageState();
}

class _SupportDetailsPageState extends State<SupportDetailsPage> {
  String phoneNumber = '';
  Map<String, dynamic>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  String distance = '';
  String timeAgo = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    e = data!['e'] as QueryDocumentSnapshot<Map<String, dynamic>>;
    distance = data!['distance'];
    timeAgo = data!['timeago'];
    phoneNumber = 'tel:${e!.data()['phone']}';
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(e!.data()['emergency'] ? Icons.info : Icons.support),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: Text(
                'Details',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: HomeSetterPage.store
                  .collection('users')
                  .doc(e!.data()['id'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    // * Make a user object
                    final AppUser user = AppUser(
                      id: snapshot.data!.data()!['id'] as String,
                      cName: snapshot.data!.data()!['cname'] as String,
                      cNumber: int.parse(
                          snapshot.data!.data()!['cnumber'] as String),
                      fullName: snapshot.data!.data()!['fullname'] as String,
                      college: snapshot.data!.data()!['college'] as String,
                      email: snapshot.data!.data()!['email'] as String,
                      intake:
                          int.parse(snapshot.data!.data()!['intake'] as String),
                      lat: snapshot.data!.data()!['lat'] as double,
                      long: snapshot.data!.data()!['long'] as double,
                      timeStamp: DateTime.parse(
                          snapshot.data!.data()!['lastonline'] as String),
                      premiumTo: snapshot.data!.data()!['premiumto'] == null
                          ? DateTime.now()
                          : DateTime.parse(snapshot.data!.data()!['premiumto'] as String),
                      photoUrl: snapshot.data!.data()!['photourl'] as String,
                      pAlways: snapshot.data!.data()!['palways'] as bool,
                      pLocation: snapshot.data!.data()!['plocation'] as bool,
                      pMaps: snapshot.data!.data()!['pmaps'] as bool,
                      pPhone: snapshot.data!.data()!['pphone'] as bool,
                      phone: snapshot.data!.data()!['phone'] as String,
                      premium: snapshot.data!.data()!['premium'] as bool,
                      verified: snapshot.data!.data()!['verified'] as String,
                      fbUrl: snapshot.data!.data()!['fburl'] as String,
                      instaUrl: snapshot.data!.data()!['instaurl'] as String,
                      celeb: snapshot.data!.data()!['celeb'] as bool,
                      treatHead: snapshot.data!.data()!['treathead'] as bool,
                      treatHunter:
                          snapshot.data!.data()!['treathunter'] as bool,
                      designation:
                          snapshot.data!.data()!['designation'] as String,
                      profession:
                          snapshot.data!.data()!['profession'] as String,
                      manualDp: snapshot.data!.data()!['manualdp'] as bool,
                      treatCount: snapshot.data!.data()!['treatcount'] as int,
                      sector: snapshot.data!.data()!['sector'] as int,
                      address: snapshot.data!.data()!['address'] as String,
                      contact: snapshot.data!.data()!['contact'] as bool,
                      coupons: snapshot.data!.data()!['coupons'] as int,
                    );
                    return Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: ContactCard(e: user),
                    );
                  }
                }
                return const SizedBox(
                  height: 100,
                );
              }),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                e!.data()['title'],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 23),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                e!.data()['body'],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    child: e!.data()['id'] != context.read<MainUser>().user!.id
                        ? ElevatedButton.icon(
                            onPressed: () {
                              launchURL(phoneNumber);
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Phone'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green[600]),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await e!.reference.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Marked help post complete'),
                                  ),
                                );
                              } catch (e) {
                                log(e.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to complete'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Mark Complete'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[500]),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Posted: $timeAgo',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Distance: $distance',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
