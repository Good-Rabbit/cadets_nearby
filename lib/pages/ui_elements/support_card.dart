import 'dart:async';

import 'package:cadets_nearby/services/calculations.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupportCard extends StatefulWidget {
  const SupportCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> e;

  @override
  State<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<SupportCard> {
  String timeAgo = '';

  void updateTime() {
    final Duration lastOnline =
        DateTime.now().difference(DateTime.parse(widget.e.data()['timestamp']));
    if (lastOnline.inSeconds <= 20) {
      timeAgo = 'Just now';
    } else if (lastOnline.inMinutes < 60) {
      timeAgo = '${lastOnline.inMinutes} mins ago';
    } else if (lastOnline.inHours < 24) {
      timeAgo = '${lastOnline.inHours} hrs ago';
    } else if (lastOnline.inHours < 47) {
      timeAgo = 'Yesterday';
    } else if (lastOnline.inDays < 7) {
      timeAgo = '${lastOnline.inDays} days ago';
    } else if (lastOnline.inDays == 7) {
      timeAgo = 'A week ago';
    } else if (lastOnline.inDays >= 7 && lastOnline.inDays <= 14) {
      timeAgo = 'More than a week ago';
    } else if (lastOnline.inDays > 14 && lastOnline.inDays <= 30) {
      timeAgo = 'More than 2 weeks ago';
    } else if (lastOnline.inDays > 30) {
      timeAgo =
          '${(lastOnline.inDays / 30).floor()} ${(lastOnline.inDays / 30).floor() == 1 ? 'month' : 'months'}ago';
    }
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
  Widget build(BuildContext context) {
    // * Distancde in m
    double distanceD = calculateDistance(
            context.read<MainUser>().user!.lat,
            context.read<MainUser>().user!.long,
            widget.e.data()['lat'],
            widget.e.data()['long']) *
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
      onTap: () {
        if (context.read<MainUser>().user!.verified == 'yes') {
          Navigator.of(context).pushNamed(
            '/supportdetails',
            arguments: {
              'e': widget.e,
              'distance': distance,
              'timeago': timeAgo,
            },
          );
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
      child: Card(
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.e.data()['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Chip(
                          label: Text(
                            widget.e.data()['emergency']
                                ? 'Emergency'
                                : 'Support',
                            style: TextStyle(
                                color: widget.e.data()['emergency']
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          backgroundColor: Colors.white,
                          avatar: Icon(
                            widget.e.data()['emergency']
                                ? Icons.info_rounded
                                : Icons.support,
                            color: widget.e.data()['emergency']
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.e.data()['body'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Posted: $timeAgo',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Row(
                      children: [
                        Text(
                          'Distance: $distance',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        if (widget.e.data()['status'] == 'waiting')
                          const SizedBox(width: 10),
                        if (widget.e.data()['status'] == 'waiting')
                          const Text(
                            'Status: Waiting',
                            style: TextStyle(color: Colors.purple),
                          ),
                      ],
                    ),
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
