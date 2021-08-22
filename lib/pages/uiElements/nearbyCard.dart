import 'package:cadets_nearby/pages/uiElements/userProfile.dart';
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
    String lastUpdate = (e.timeStamp.day.toString() +
        '/' +
        e.timeStamp.month.toString() +
        '/' +
        e.timeStamp.year.toString());
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
                        borderRadius: BorderRadius.vertical(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          e.cName,
                        ),
                        if (e.celeb)
                          Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.green,
                          ),
                        if (e.verified != 'yes')
                          Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                    if (e.premium)
                      Text(
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
                      Icon(
                        Icons.visibility_off_rounded,
                        size: 17,
                      ),
                    Text('Last update: ' + lastUpdate),
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
