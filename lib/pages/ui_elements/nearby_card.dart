import 'package:cadets_nearby/pages/ui_elements/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/services/user.dart';

class NearbyCard extends StatelessWidget {
  const NearbyCard({
    Key? key,
    required this.e,
    required this.isKm,
    required this.distanceKm,
    required this.distanceM,
  }) : super(key: key);

  final AppUser e;
  final bool isKm;
  final double distanceKm;
  final int distanceM;

  @override
  Widget build(BuildContext context) {
    final List<String> dt = e.timeStamp.toString().split(' ');
    final List<String> dateTemp = dt[0].split('-');
    final String date = '${dateTemp[2]}/${dateTemp[1]}/${dateTemp[2]}';
    final List<String> t = dt[1].split(':');
    final String time = '${t[0]}:${t[1]}';
    final String lastUpdate = '  $time $date';
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    maxChildSize: 0.9,
                    minChildSize: 0.5,
                    builder: (_, controller) => Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15.0),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: ListView(
                        controller: controller,
                        children: [UserProfile(e: e)],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: e.photoUrl == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            e.photoUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          e.cName,
                        ),
                        if (e.celeb)
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.green,
                          ),
                        if (e.verified != 'yes')
                          const Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                    if (e.premium)
                      const Text(
                        'Premium User',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    if (e.pLocation)
                      Text(
                        (isKm ? distanceKm.toString() : distanceM.toString()) +
                            (isKm ? 'km' : 'm'),
                      ),
                    if (!e.pLocation)
                      const Icon(
                        Icons.visibility_off_rounded,
                        size: 17,
                      ),
                    Text('Last update: $lastUpdate'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
