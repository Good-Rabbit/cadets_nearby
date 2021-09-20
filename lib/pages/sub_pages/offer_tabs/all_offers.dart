import 'package:cadets_nearby/pages/ui_elements/no_offers.dart';
import 'package:cadets_nearby/pages/ui_elements/offer_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../home_setter.dart';

class AllOffersTab extends StatefulWidget {
  const AllOffersTab({Key? key}) : super(key: key);

  @override
  State<AllOffersTab> createState() => _AllOffersTabState();
}

class _AllOffersTabState extends State<AllOffersTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: HomeSetterPage.store.collection('offers').orderBy('priority').snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          if (snapshots.data!.docs.isNotEmpty) {
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ...snapshots.data!.docs.map((e) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: OfferCard(e: e),
                  );
                }),
              ],
            );
          } else {
            return noOffersOngoing(context);
          }
        }
        return const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

