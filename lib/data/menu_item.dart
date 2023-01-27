import 'package:flutter/material.dart';

class CustomMenuItem {
  final String name;
  final Icon icon;

  const CustomMenuItem({required this.name, required this.icon});
}

class MenuItems {

  static const List<CustomMenuItem> first = [
    itemAccount,
    itemAbout,
  ];

    static const List<CustomMenuItem> second = [
    itemSignOut,
    itemRateUs,
  ];

  static const itemAccount = CustomMenuItem(
    name: 'Account',
    icon: Icon(Icons.account_circle_rounded),
  );
  static const itemAbout = CustomMenuItem(
    name: 'About',
    icon: Icon(Icons.info),
  );
  static const itemSignOut = CustomMenuItem(
    name: 'Sign Out',
    icon: Icon(Icons.logout),
  );
    static const itemRateUs = CustomMenuItem(
    name: 'Rate Us',
    icon: Icon(Icons.star_rounded),
  );
}
