import 'dart:math';

import 'package:cadets_nearby/pages/home_setter.dart';

class AppUser {
  int cNumber;
  int intake;
  int latSector;
  int coupons;
  double lat;
  double long;
  String id;
  String fullName;
  String college;
  String cName;
  String email;
  String photoUrl;
  String phone;
  String fbUrl;
  String instaUrl;
  String designation;
  String profession;
  String address;
  String verified;
  DateTime timeStamp;
  DateTime premiumTo;
  bool pLocation;
  bool premium;
  bool pPhone;
  bool celeb;
  bool pMaps;
  bool manualDp;
  bool contact;

  AppUser({
    required this.cName,
    required this.cNumber,
    required this.fullName,
    required this.college,
    required this.email,
    required this.intake,
    required this.premium,
    required this.pLocation,
    required this.pPhone,
    required this.verified,
    required this.celeb,
    required this.id,
    required this.timeStamp,
    required this.fbUrl,
    required this.instaUrl,
    required this.designation,
    required this.profession,
    required this.manualDp,
    required this.latSector,
    required this.address,
    required this.contact,
    required this.coupons,
    required this.premiumTo,
    this.photoUrl = '',
    this.lat = 0,
    this.long = 0,
    this.phone = '',
    this.pMaps = false,
  });

  bool equals(AppUser user) => user.id == id;
  bool notEquals(AppUser user) => user.id != id;

  double distanceFromUser(AppUser user) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((user.lat - lat) * p) / 2 +
        c(lat * p) * c(user.lat * p) * (1 - c((user.long - long) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double distance(double lat, double long) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((lat - this.lat) * p) / 2 +
        c(this.lat * p) * c(lat * p) * (1 - c((long - this.long) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static AppUser fromData(Map<String, dynamic> e) {
    return AppUser(
      id: e['id'] == null
          ? HomeSetterPage.auth.currentUser!.uid
          : e['id'] as String,
      cName: e['cname'] as String,
      cNumber: int.parse(e['cnumber'] as String),
      fullName: e['fullname'] as String,
      college: e['college'] as String,
      email: e['email'] as String,
      intake: int.parse(e['intake'] as String),
      lat: e['lat'] as double,
      long: e['long'] as double,
      timeStamp: e['lastonline'] == null
          ? DateTime(2000)
          : DateTime.parse(e['lastonline']),
      premiumTo: e['premiumto'] == null
          ? DateTime.now()
          : DateTime.parse(e['premiumto'] as String),
      photoUrl: e['photourl'] as String,
      pLocation: e['plocation'] as bool,
      pMaps: e['pmaps'] as bool,
      pPhone: e['pphone'] as bool,
      phone: e['phone'] as String,
      premium: e['premium'] as bool,
      verified: e['verified'] as String,
      fbUrl: e['fburl'] as String,
      instaUrl: e['instaurl'] as String,
      celeb: e['celeb'] as bool,
      designation: e['designation'] as String,
      profession: e['profession'] as String,
      manualDp: e['manualdp'] as bool,
      latSector: (e['latsector'] ?? 0) as int,
      address: e['address'] as String,
      contact: e['contact'] as bool,
      coupons: e['coupons'] as int,
    );
  }
}
