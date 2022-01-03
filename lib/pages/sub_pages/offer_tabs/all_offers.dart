import 'package:cadets_nearby/pages/ui_elements/filter_range.dart';
import 'package:cadets_nearby/pages/ui_elements/no_offers.dart';
import 'package:cadets_nearby/pages/ui_elements/offer_card.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../home_setter.dart';

class AllOffersTab extends StatefulWidget {
  const AllOffersTab({Key? key}) : super(key: key);

  @override
  State<AllOffersTab> createState() => _AllOffersTabState();
}

class _AllOffersTabState extends State<AllOffersTab> {
  int count = 0;
  RangeValues range = const RangeValues(0, 150);

  @override
  Widget build(BuildContext context) {
    count = 0;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: HomeSetterPage.store
          .collection('offers')
          .orderBy('priority')
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          if (snapshots.data!.docs.isNotEmpty) {
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                topRow(context),
                ...snapshots.data!.docs.map((e) {
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
                  if (distanceKm >= range.start && distanceKm <= range.end) {
                    count++;
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
                if (count == 0)
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 3,
                      child: noOffersOngoing(context)),
              ],
            );
          } else {
            return Column(
              children: [
                topRow(context),
                Expanded(child: noOffersOngoing(context)),
              ],
            );
          }
        }
        return const SizedBox();
      },
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
            content: Column(
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
                FilterRange(
                  range: range,
                  divisions: 15,
                  min: 0.floorToDouble(),
                  max: 150.ceilToDouble(),
                  onChanged: (value) {
                    setState(() {
                      range = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done')),
            ],
          );
        });
  }
}

class CouponCount extends StatelessWidget {
  const CouponCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.ticketAlt,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          context.watch<MainUser>().user!.coupons.toString(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
