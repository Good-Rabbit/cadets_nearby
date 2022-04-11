import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_setter.dart';
import '../../ui_elements/no_offers.dart';
import '../../ui_elements/offer_card.dart';
import 'ui_elements/offers_top_row.dart';

class OfferList extends StatelessWidget {
  const OfferList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> whereInLat = [
      context.read<MainUser>().user!.latSector + 3,
      context.read<MainUser>().user!.latSector + 2,
      context.read<MainUser>().user!.latSector + 1,
      context.read<MainUser>().user!.latSector,
      context.read<MainUser>().user!.latSector - 1,
      context.read<MainUser>().user!.latSector - 2,
      context.read<MainUser>().user!.latSector - 3,
    ];

    return Column(
      children: [
        OffersTopRow(context: context),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('offers')
                .where('long',
                    isLessThan: context.read<MainUser>().user!.long + 0.0543,
                    isGreaterThan: context.read<MainUser>().user!.long - 0.0543)
                .where('latsector', whereIn: whereInLat)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> offers =
                    snapshot.data!.docs;
                if (offers.isNotEmpty) {
                  // Sort offers by priority
                  offers.sort(
                      (a, b) => a.data()['priority'] - b.data()['priority']);

                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!.docs.map((e) {
                        // * Distance in meter rounded to tens
                        int distanceM = (calculateDistance(
                                    context.read<MainUser>().user!.lat,
                                    context.read<MainUser>().user!.long,
                                    double.parse(e.data()['lat']),
                                    double.parse(e.data()['long'])) *
                                1000)
                            .toInt();
                        double distanceKm = distanceM / 1000;

                        if (distanceKm <= 6) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: OfferCard(
                              e: e.data(),
                              distanceM: distanceM,
                            ),
                          );
                        }
                        return const SizedBox();
                      }).toList(),
                    ),
                  );
                } else {
                  return Expanded(child: noOffersOngoing(context));
                }
              } else {
                return Expanded(child: noOffersOngoing(context));
              }
            }),
      ],
    );
  }
}
