import 'package:flutter/material.dart';

Widget noOffersOngoing(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.backpack,
          size: 70.0,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          'No offers ongoing',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    ),
  );
}
