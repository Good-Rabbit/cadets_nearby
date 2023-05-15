import 'package:flutter/material.dart';

import 'coupon_count.dart';

class OffersTopRow extends StatelessWidget {
  const OffersTopRow({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/availedoffers');
            },
            icon: const Icon(Icons.menu),
            label: const Text(
              'Availed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const CouponCount(),
      ],
    );
  }
}
