import 'dart:math';

import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferOnMapPage extends StatelessWidget {
  OfferOnMapPage({Key? key}) : super(key: key);

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final offer =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    double zoom = 16;
    double distance = context.read<MainUser>().user!.distance(
              offer['lat'],
              offer['long'],
            ) *
        1000;

    // * Calculate zoom based on distance
    double logBase(num x, num base) => log(x) / log(base);
    zoom -= logBase(distance / 550, 2);

    return SafeArea(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(
              (offer['lat'] + context.read<MainUser>().user!.lat) / 2,
              (offer['long'] + context.read<MainUser>().user!.long) / 2),
          zoom: zoom,
        ),
        nonRotatedChildren: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'https://www.openstreetmap.org/assets/osm_logo-9391021d40a7acdafd2ac5d5622dfe0e469c61421fdb2975365c183f5edaa270.png',
                      width: 50,
                      height: 50,
                    ),
                    FilledButton.icon(
                      label: const Text('Directions'),
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                            'https://www.google.com/maps/dir/?api=1&destination=${offer["lat"]}%2C${offer["long"]}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.directions),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.goodrabbit.cadets_nearby',
          ),
          MarkerLayer(
            markers: [
              marker(
                context,
                lat: context.read<MainUser>().user!.lat,
                long: context.read<MainUser>().user!.long,
                imageUrl: context.read<MainUser>().user!.photoUrl,
                isOffer: false,
              ),
              marker(
                context,
                lat: offer['lat'],
                long: offer['long'],
                imageUrl: offer['imageurl'],
                isOffer: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Marker marker(BuildContext context,
      {required double lat,
      required double long,
      required String imageUrl,
      required bool isOffer}) {
    Color pinBorderColor = Colors.green[400]!;

    // Determine if image of offer
    Widget offerImage = Image.asset('assets/images/user.png');
    if (isOffer) {
      offerImage = Icon(
        Icons.star_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      );
    } else if (imageUrl != '') {
      offerImage = Image.network(imageUrl);
    }

    return Marker(
      width: 85,
      height: 85,
      point: LatLng(lat, long),
      builder: (context) {
        return Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    color: isOffer ? Colors.white : pinBorderColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: offerImage,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: isOffer ? Colors.white : pinBorderColor,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
