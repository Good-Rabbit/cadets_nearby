import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final Icon icon;

  const MenuItem({required this.name, required this.icon});
}

class MenuItems {

  static const List<MenuItem> first = [
    itemAccount,
    itemAbout,
  ];

    static const List<MenuItem> second = [
    itemSignOut,
    itemRateUs,
  ];

  static const itemAccount = MenuItem(
    name: 'Account',
    icon: Icon(Icons.account_circle_rounded),
  );
  static const itemAbout = MenuItem(
    name: 'About',
    icon: Icon(Icons.info),
  );
  static const itemSignOut = MenuItem(
    name: 'Sign Out',
    icon: Icon(Icons.logout),
  );
    static const itemRateUs = MenuItem(
    name: 'Rate Us',
    icon: Icon(Icons.star_rounded),
  );
}
