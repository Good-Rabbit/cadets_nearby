import 'dart:async';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainUser with ChangeNotifier {
  AppUser? mainUser;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? userStream;
  StreamSubscription? userStreamSubscription;

  set user(AppUser? user) {
    mainUser = user;
    notifyListeners();
  }

  AppUser? get user => mainUser;

  Future<void> setWithUser(User user) async {
    userStream =
        HomeSetterPage.store.collection('users').doc(user.uid).snapshots();
    userStreamSubscription = userStream!.listen((u) {
      if (u.data() != null) {
        mainUser = AppUser.fromData(u.data()!);
        if (mainUser!.premiumTo.difference(DateTime.now()).inDays < 1 &&
            mainUser!.timeStamp.month != DateTime.now().month) {
          HomeSetterPage.store.collection('users').doc(user.uid).update({
            'premium': false,
            'coupons': 3,
          });
        } else {
          if (mainUser!.premiumTo.difference(DateTime.now()).inDays < 1) {
            if (mainUser!.premium) {
              HomeSetterPage.store.collection('users').doc(user.uid).update({
                'premium': false,
                if (mainUser!.coupons > 3) 'coupons': 3,
              });
            }
          }
          if (mainUser!.timeStamp.month != DateTime.now().month) {
            if (mainUser!.premium) {
              if (mainUser!.coupons != 20) {
                HomeSetterPage.store
                    .collection('users')
                    .doc(user.uid)
                    .update({'coupons': 20});
              }
            } else if (mainUser!.coupons != 3) {
              HomeSetterPage.store
                  .collection('users')
                  .doc(user.uid)
                  .update({'coupons': 3});
            }
          }
        }
        notifyListeners();
      } else {
        mainUser = null;
        notifyListeners();
      }
    });
  }
}
