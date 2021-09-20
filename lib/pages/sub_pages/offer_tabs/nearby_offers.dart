import 'package:cadets_nearby/pages/ui_elements/no_offers.dart';
import 'package:cadets_nearby/pages/ui_elements/offer_card.dart';
import 'package:cadets_nearby/services/nearby_offers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyOffersTab extends StatefulWidget {
  const NearbyOffersTab({Key? key}) : super(key: key);

  @override
  State<NearbyOffersTab> createState() => _NearbyOffersTabState();
}

class _NearbyOffersTabState extends State<NearbyOffersTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        if (context.watch<NearbyOffers>().nearbyOffers.isEmpty)
          noOffersOngoing(context),
        if (context.watch<NearbyOffers>().nearbyOffers.isNotEmpty)
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ...context.watch<NearbyOffers>().nearbyOffers.map((e) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: OfferCard(e: e),
                  );
                }),
              ],
            ),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}