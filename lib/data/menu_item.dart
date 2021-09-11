import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final Icon icon;

  const MenuItem({required this.name, required this.icon});
}

class MenuItems {

  static const List<MenuItem> first = [
    itemAbout,
  ];

    static const List<MenuItem> second = [
    itemSignOut,
  ];

  static const itemAbout = MenuItem(
    name: 'About',
    icon: Icon(Icons.info),
  );
  static const itemSignOut = MenuItem(
    name: 'Sign Out',
    icon: Icon(Icons.logout),
  );
}
