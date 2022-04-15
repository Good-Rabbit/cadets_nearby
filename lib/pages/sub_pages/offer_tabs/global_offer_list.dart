import 'package:cadets_nearby/pages/sub_pages/offer_tabs/ui_elements/offers_top_row.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/global_offers_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui_elements/no_offers.dart';
import '../../ui_elements/offer_card.dart';

class GlobalOfferList extends StatelessWidget {
  const GlobalOfferList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OffersTopRow(context: context),
        const SizedBox(
          height: 20,
        ),
        if (context.watch<GlobalOffers>().offers.isNotEmpty)
          SingleChildScrollView(
            child: Column(
              children: context.read<GlobalOffers>().offers.map((e) {
                // * Distance in meter rounded to tens
                int distanceM = (calculateDistance(
                            context.read<MainUser>().user!.lat,
                            context.read<MainUser>().user!.long,
                            double.parse(e['lat']),
                            double.parse(e['long'])) *
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
            ),
          ),
        if (context.read<GlobalOffers>().offers.isEmpty)
          Expanded(child: noOffersOngoing(context)),
      ],
    );
  }
}
