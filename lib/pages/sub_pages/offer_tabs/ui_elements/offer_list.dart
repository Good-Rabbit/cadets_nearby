import 'package:cadets_nearby/pages/ui_elements/filter_days.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/offers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui_elements/no_offers.dart';
import '../../../ui_elements/offer_card.dart';
import 'coupon_count.dart';

class OfferList extends StatelessWidget {
  const OfferList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<Offers>().count = 0;
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        topRow(context),
        ...context.watch<Offers>().offers.map((e) {
          // * Distancde in m
          double distanceD = calculateDistance(
                  context.read<MainUser>().user!.lat,
                  context.read<MainUser>().user!.long,
                  double.parse(e.data()['lat']),
                  double.parse(e.data()['long'])) *
              1000;
          // * Distance in meter rounded to tens
          int distanceM = distanceD.toInt();
          double distanceKm = distanceM / 1000;
          if (distanceKm <= context.read<Offers>().range ) {
            context.read<Offers>().count++;
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: OfferCard(
                e: e,
                distanceM: distanceM,
              ),
            );
          }
          return const SizedBox();
        }),
        if (context.read<Offers>().count == 0)
          SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: noOffersOngoing(context)),
      ],
    );
  }

  Row topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                showFilter(context);
              },
              icon: Icon(
                Icons.filter_alt_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const CouponCount(),
      ],
    );
  }

  Future<dynamic> showFilter(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          title: const Text('Filter'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'By Distance',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                FilterSlider(
                  value: context.read<Offers>().range,
                  divisions: 15,
                  unit: 'km',
                  min: 0.floorToDouble(),
                  max: 150.ceilToDouble(),
                  onChanged: (value) {
                    context.read<Offers>().range = value.toInt();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text('Done')),
          ],
        );
      },
    );
  }
}
