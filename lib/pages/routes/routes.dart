import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

List<Destination> destinations = [
  const Destination(
    title: 'Nearby',
    icon: Icons.near_me_rounded,
  ),
  const Destination(
    title: 'Offers',
    icon: Icons.backpack_rounded,
  ),
  const Destination(
    title: 'Feed',
    icon: Icons.feed_rounded,
  ),
  const Destination(
    title: 'Contact',
    icon: Icons.contacts_rounded,
  ),
];
