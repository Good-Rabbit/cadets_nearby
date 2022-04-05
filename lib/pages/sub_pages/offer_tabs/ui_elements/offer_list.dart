import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../home_setter.dart';
import '../../../ui_elements/no_offers.dart';
import '../../../ui_elements/offer_card.dart';

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
    List<int> whereInLong = [
      context.read<MainUser>().user!.longSector + 3,
      context.read<MainUser>().user!.longSector + 2,
      context.read<MainUser>().user!.longSector + 1,
      context.read<MainUser>().user!.longSector,
      context.read<MainUser>().user!.longSector - 1,
      context.read<MainUser>().user!.longSector - 2,
      context.read<MainUser>().user!.longSector - 3,
    ];

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('offers')
                .orderBy('priority')
                .where('latsector', whereIn: whereInLat)
                .where('longsector', whereIn: whereInLong)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!.docs.map((e) {

                      // * Distance in meter rounded to tens
                      int distanceM = (calculateDistance(
                              context.read<MainUser>().user!.lat,
                              context.read<MainUser>().user!.long,
                              double.parse(e.data()['lat']),
                              double.parse(e.data()['long'])) *
                          1000).toInt();
                      double distanceKm = distanceM / 1000;

                      if (distanceKm <= 6) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: OfferCard(
                            e: e,
                            distanceM: distanceM,
                          ),
                        );
                      }
                      return const SizedBox();
                    }).toList(),
                  ),
                );
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 2 / 3,
                    child: noOffersOngoing(context));
              }
            }),
      ],
    );
  }

  // Row topRow(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           const SizedBox(
  //             width: 20,
  //           ),
  //           IconButton(
  //             onPressed: () {
  //               showFilter(context);
  //             },
  //             icon: Icon(
  //               Icons.filter_alt_rounded,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const CouponCount(),
  //     ],
  //   );
  // }

  // Future<dynamic> showFilter(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Theme.of(context).bottomAppBarColor,
  //         title: const Text('Filter'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               const Text(
  //                 'By Distance',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               FilterSlider(
  //                 value: context.read<Offers>().range,
  //                 divisions: 15,
  //                 unit: 'km',
  //                 min: 0.floorToDouble(),
  //                 max: 150.ceilToDouble(),
  //                 onChanged: (value) {
  //                   context.read<Offers>().range = value.toInt();
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('Done')),
  //         ],
  //       );
  //     },
  //   );
  // }

}
