import 'dart:async';

import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> e;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
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
    } else if (lastOnline.inDays < 30) {
      timeAgo = '${lastOnline.inDays} days ago';
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
    return InkWell(
      onTap: () {
        if (context.read<MainUser>().user!.verified == 'yes') {
          Navigator.of(context).pushNamed(
            '/feeddetails',
            arguments: {
              'e': widget.e,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.e.data()['imageurl'],
                        height: 170,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.e.data()['minidescription'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.e.data()['body'],
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Posted: $timeAgo',
                      style: TextStyle(color: Theme.of(context).primaryColor),
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
