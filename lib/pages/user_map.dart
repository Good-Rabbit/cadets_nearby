import 'dart:math';

import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserOnMapPage extends StatelessWidget {
  UserOnMapPage({Key? key}) : super(key: key);

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as AppUser;

    double zoom = 16;
    double distance = user.distance(
          context.read<MainUser>().user!.lat,
          context.read<MainUser>().user!.long,
        ) *
        1000;

    // * Calculate zoom based on distance
    double logBase(num x, num base) => log(x) / log(base);
    zoom -= logBase(distance / 550, 2);

    return SafeArea(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng((user.lat + context.read<MainUser>().user!.lat) / 2,
              (user.long + context.read<MainUser>().user!.long) / 2),
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
                    ElevatedButton.icon(
                      label: const Text('Directions'),
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                            'https://www.google.com/maps/dir/?api=1&destination=${user.lat}%2C${user.long}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.directions),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
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
              markerWithUser(context, context.read<MainUser>().user!),
              markerWithUser(context, user),
            ],
          ),
        ],
      ),
    );
  }

  Marker markerWithUser(BuildContext context, AppUser user) {
    Color pinBorderColor = Colors.green[400]!;

    return Marker(
      width: 85,
      height: 85,
      point: LatLng(user.lat, user.long),
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
                    color: pinBorderColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: user.photoUrl == ''
                          ? Image.asset('assets/images/user.png')
                          : Image.network(
                              user.photoUrl,
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: pinBorderColor,
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
