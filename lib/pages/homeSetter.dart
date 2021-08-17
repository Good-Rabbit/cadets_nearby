import 'package:cadets_nearby/pages/completeAccountPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cadets_nearby/pages/home.dart';
import 'package:cadets_nearby/pages/login.dart';
import 'package:cadets_nearby/services/user.dart';

class HomeSetterPage extends StatefulWidget {
  HomeSetterPage({Key? key}) : super(key: key);
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static AppUser? mainUser;
  static setMainUser(User? user) async {
    var u = await HomeSetterPage.store.collection('users').doc(user!.uid).get();
    HomeSetterPage.mainUser = AppUser(
      id: HomeSetterPage.auth.currentUser!.uid,
      cName: u.data()!['cname'],
      cNumber: int.parse(u.data()!['cnumber']),
      fullName: u.data()!['fullname'],
      college: u.data()!['college'],
      email: u.data()!['email'],
      intake: int.parse(u.data()!['intake']),
      lat: u.data()!['lat'],
      long: u.data()!['long'],
      pAlways: u.data()!['palways'],
      pLocation: u.data()!['plocation'],
      pMaps: u.data()!['pmaps'],
      pPhone: u.data()!['pphone'],
      photoUrl: u.data()!['photourl'],
      phone: u.data()!['phone'],
      timeStamp: DateTime.parse(u.data()!['lastonline']),
      premium: u.data()!['premium'],
      fbUrl: u.data()!['fburl'],
      instaUrl: u.data()!['instaurl'],
      verified: u.data()!['verified'],
      celeb: u.data()!['celeb'],
      bountyHead: u.data()!['bountyhead'],
      bountyHunter: u.data()!['bountyhunter'],
      workplace: u.data()!['workplace'],
      profession: u.data()!['profession'],
    );
  }

  @override
  _HomeSetterPageState createState() => _HomeSetterPageState();
}

class _HomeSetterPageState extends State<HomeSetterPage> {
  User? user;

  loggedInNotifier() {
    setState(() {});
  }

  @override
  void initState() {
    user = HomeSetterPage.auth.currentUser;
    if (user != null) {
      HomeSetterPage.setMainUser(user!);
    }
    HomeSetterPage.auth.authStateChanges().listen(
      (user) {
        if (mounted) {
          if (this.user != user) {
            setState(
              () {
                this.user = user;
                if (user != null) {
                  HomeSetterPage.setMainUser(user);
                } else {
                  HomeSetterPage.mainUser = null;
                }
              },
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return FutureBuilder(
        future: HomeSetterPage.store.collection('users').doc(user!.uid).get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() == null) {
                return CompleteAccountPage(
                  loggedInNotifier: loggedInNotifier,
                );
              } else {
                if (HomeSetterPage.mainUser == null)
                  HomeSetterPage.setMainUser(user);

                // Display home
                return RealHome();
              }
            }
          }
          return Scaffold();
        },
      );
    } else {
      // return RealHome();
      return LoginPage();
    }
  }
}
