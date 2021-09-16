import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class OfferCard extends StatefulWidget {
  const OfferCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> e;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    // * Distancde in m
    double distanceD = calculateDistance(
            context.read<MainUser>().user!.lat,
            context.read<MainUser>().user!.long,
            double.parse(widget.e.data()['lat']),
            double.parse(widget.e.data()['long'])) *
        1000;
    // * Distance in meter rounded to tens
    int distanceM = distanceD.toInt();
    bool isKm = false;
    double distanceKm = 0;
    if (distanceM > 1000) {
      isKm = true;
      distanceKm = distanceD.roundToDouble() - distanceD.roundToDouble() % 10;
      distanceKm /= 1000;
      distanceKm = double.parse(distanceKm.toStringAsFixed(2));
    } else if (distanceM >= 10) {
      distanceM = distanceM - distanceM % 10;
    }
    String distance = '${isKm ? distanceKm : distanceM} ${isKm ? 'km' : 'm'}';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/offerdetails',
          arguments: {'e': widget.e, 'distance': distance},
        );
      },
      child: Card(
        color: Colors.orange[50],
        child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: CircleAvatar(
                    radius: 35.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.network(
                        widget.e.data()['imageurl'],
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.e.data()['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.e.data()['minidescription'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Distance: $distance',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (context.read<MainUser>().user!.coupons > 0) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Avail this offer?'),
                                content: Text(
                                    'Currently you have ${context.read<MainUser>().user!.coupons.toString()} coupons left. This will cost you 1 coupon.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No, go back.')),
                                  TextButton(
                                      onPressed: inProgress
                                          ? null
                                          : () {
                                              setState(() {
                                                inProgress = true;
                                              });
                                              if (context
                                                      .read<MainUser>()
                                                      .user!
                                                      .coupons >
                                                  0) {
                                                HomeSetterPage.store
                                                    .collection('users')
                                                    .doc(context
                                                        .read<MainUser>()
                                                        .user!
                                                        .id)
                                                    .update({
                                                  'coupons': (context
                                                          .read<MainUser>()
                                                          .user!
                                                          .coupons -
                                                      1),
                                                });
                                              }
                                              HomeSetterPage.store
                                                  .collection('codes')
                                                  .add({
                                                'id': context
                                                    .read<MainUser>()
                                                    .user!
                                                    .id,
                                                'title':
                                                    widget.e.data()['title'],
                                                'offerid':
                                                    widget.e.data()['code'],
                                                'code':
                                                    '${widget.e.data()['code']}${context.read<MainUser>().user!.cNumber}${DateTime.now().toString()}',
                                                'expiry': DateTime.now().add(
                                                    const Duration(days: 7)).toString(),
                                              });
                                              Navigator.of(context).pop();
                                              setState(() {
                                                inProgress = false;
                                              });
                                            },
                                      child: const Text('Yes.')),
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Out of coupons!'),
                                content: const Text(
                                    'You are all out of coupons. Subscribe to premium to get unlimited coupons'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Avail')),
              ],
            )),
      ),
    );
  }
}
