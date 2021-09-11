import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> e;

  @override
  Widget build(BuildContext context) {
    // * Distancde in m
    double distanceD = calculateDistance(
            context.read<MainUser>().user!.lat,
            context.read<MainUser>().user!.long,
            e.data()['lat'],
            e.data()['long']) *
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.data()['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    e.data()['body'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Distance: ${isKm ? distanceKm : distanceM}${isKm ? 'km' : 'm'}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
