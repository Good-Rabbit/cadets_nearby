import 'dart:async';

import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/pages/ui_elements/user_profile.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyCard extends StatefulWidget {
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
  NearbyCardState createState() => NearbyCardState();
}

class NearbyCardState extends State<NearbyCard> {
  String timeAgo = '';

  void updateTime() {
    final Duration lastOnline = DateTime.now().difference(widget.e.timeStamp);
    if (lastOnline.inSeconds <= 60) {
      timeAgo = 'active now';
    } else if (lastOnline.inMinutes < 60) {
      int mins = lastOnline.inHours;
      timeAgo = '$mins ${mins == 1 ? 'min' : 'mins'} ago';
    } else if (lastOnline.inHours < 24) {
      int hours = lastOnline.inHours;
      timeAgo = '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (lastOnline.inHours < 47) {
      timeAgo = 'Yesterday';
    } else if (lastOnline.inDays < 30) {
      int days = lastOnline.inDays;
      timeAgo = '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (lastOnline.inDays < 365) {
      int months = lastOnline.inDays ~/ 30;
      timeAgo = '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      int years = (lastOnline.inDays ~/ 365);
      timeAgo = '$years ${years == 1 ? 'year' : 'years'} ago';
    }
    //  else if (lastOnline.inDays == 7) {
    //   timeAgo = 'A week ago';
    // } else if (lastOnline.inDays >= 7 && lastOnline.inDays <= 14) {
    //   timeAgo = 'More than a week ago';
    // } else if (lastOnline.inDays > 14 && lastOnline.inDays <= 30) {
    //   timeAgo = 'More than 2 weeks ago';
    // }
  }

  @override
  void initState() {
    updateTime();
    Timer.periodic(const Duration(minutes: 2), (timer) {
      updateTime();
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (context.read<MainUser>().user!.verified == 'yes') {
          showBottomSheetWith([UserProfile(e: widget.e)], context);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Get verified first'),
                  content: const Text(
                      'You have to get verified first to be able to use this'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok.')),
                  ],
                );
              });
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: widget.e.photoUrl == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            widget.e.photoUrl,
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
                          widget.e.cName,
                        ),
                        if (widget.e.celeb)
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.green,
                          ),
                        if (widget.e.verified != 'yes')
                          const Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                    if (widget.e.pLocation)
                      Text(
                        (widget.isKm
                                ? widget.distanceKm.toString()
                                : widget.distanceM.toString()) +
                            (widget.isKm ? ' km' : ' m'),
                      ),
                    if (!widget.e.pLocation)
                      const Icon(
                        Icons.visibility_off_rounded,
                        size: 17,
                      ),
                    Text('Last update: $timeAgo'),
                  ],
                ),
              ),
              Transform(
                transform: Matrix4.identity()..scale(0.8),
                child: Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    widget.e.intake.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
