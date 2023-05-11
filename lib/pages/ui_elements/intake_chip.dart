import 'package:flutter/material.dart';

class IntakeChip extends StatelessWidget {
  const IntakeChip({
    Key? key,
    required this.year,
  }) : super(key: key);

  final String year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Transform(
        transform: Matrix4.identity()..scale(0.9),
        child: Chip(
          backgroundColor: Theme.of(context).primaryColor,
          label: Text(
            year,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
