import 'package:cadets_nearby/services/global_offers_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui_elements/no_offers.dart';
import '../../../ui_elements/offer_card.dart';

class GlobalOfferList extends StatelessWidget {
  const GlobalOfferList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<GlobalOffers>().offers.isNotEmpty) {
      return ListView(
        children: context.read<GlobalOffers>().offers.map((e) {
          // * Distance in meter rounded to tens
          int distanceM = (context
                      .read<MainUser>()
                      .user!
                      .distance(e['lat'] as double, e['long'] as double) *
                  1000)
              .toInt();

          return Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: OfferCard(
              e: e,
              distanceM: distanceM,
            ),
          );
        }).toList(),
      );
    } else {
      return noOffersOngoing(context);
    }
  }
}
