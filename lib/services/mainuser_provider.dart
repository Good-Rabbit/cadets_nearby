import 'dart:async';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MainUser with ChangeNotifier {
  AppUser? mainUser;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? userStream;
  StreamSubscription? userStreamSubscription;

  set user(AppUser? user) {
    mainUser = user;
    notifyListeners();
  }

  AppUser? get user => mainUser;

  // // ignore: avoid_setters_without_getters
  // set setLat(double lat) {
  //   mainUser!.lat = lat;
  // }

  // // ignore: avoid_setters_without_getters
  // set setLong(double long) {
  //   mainUser!.long = long;
  // }

  // // ignore: avoid_setters_without_getters
  // set setPhotoUrl(String url) {
  //   mainUser!.photoUrl = url;
  //   notifyListeners();
  // }

  Future<void> setWithUser(User user) async {
    userStream =
        HomeSetterPage.store.collection('users').doc(user.uid).snapshots();
    userStreamSubscription = userStream!.listen((u) {
      mainUser = AppUser(
        id: HomeSetterPage.auth.currentUser!.uid,
        cName: u.data()!['cname'] as String,
        cNumber: int.parse(u.data()!['cnumber'] as String),
        fullName: u.data()!['fullname'] as String,
        college: u.data()!['college'] as String,
        email: u.data()!['email'] as String,
        intake: int.parse(u.data()!['intake'] as String),
        lat: u.data()!['lat'] as double,
        long: u.data()!['long'] as double,
        pAlways: u.data()!['palways'] as bool,
        pLocation: u.data()!['plocation'] as bool,
        pMaps: u.data()!['pmaps'] as bool,
        pPhone: u.data()!['pphone'] as bool,
        photoUrl: u.data()!['photourl'] as String,
        phone: u.data()!['phone'] as String,
        timeStamp: DateTime.parse(u.data()!['lastonline'] as String),
        premium: u.data()!['premium'] as bool,
        fbUrl: u.data()!['fburl'] as String,
        instaUrl: u.data()!['instaurl'] as String,
        verified: u.data()!['verified'] as String,
        celeb: u.data()!['celeb'] as bool,
        treatHead: u.data()!['treathead'] as bool,
        treatHunter: u.data()!['treathunter'] as bool,
        designation: u.data()!['designation'] as String,
        profession: u.data()!['profession'] as String,
        manualDp: u.data()!['manualdp'] as bool,
        treatCount: u.data()!['treatcount'] as int,
        sector: u.data()!['sector'] as int,
        address: u.data()!['address'] as String,
        contact: u.data()!['contact'] as bool,
        coupons: u.data()!['coupons'] as int,
      );
      if (mainUser!.timeStamp.month != DateTime.now().month) {
        HomeSetterPage.store
            .collection('users')
            .doc(user.uid)
            .update({'coupons': 2});
      }
      notifyListeners();
    });
  }
}
