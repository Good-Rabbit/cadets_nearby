import 'package:flutter/material.dart';

Widget noOneFound(context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 3 / 5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          Icons.no_accounts,
          size: 70.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          'No one found',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}
