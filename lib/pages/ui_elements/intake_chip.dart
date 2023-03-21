import 'package:flutter/material.dart';

class IntakeChip extends StatelessWidget {
  const IntakeChip({
    Key? key,
    required this.year,
  }) : super(key: key);

  final String year;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..scale(0.8),
      child: Chip(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          year,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}