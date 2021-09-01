import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MainUser with ChangeNotifier {
  AppUser? mainUser;

  set user(AppUser? user) {
    mainUser = user;
    notifyListeners();
  }

  AppUser? get user => mainUser;

  // ignore: avoid_setters_without_getters
  set setLat(double lat){
    mainUser!.lat = lat;
  }

  // ignore: avoid_setters_without_getters
  set setLong(double long){
    mainUser!.long = long;
  }

  Future<void> setWithUser(User user)async{
    final u =
        await HomeSetterPage.store.collection('users').doc(user.uid).get();
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
      district: u.data()!['district'] as String,
    );
  }
}
