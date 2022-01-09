import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FeedDetailsPage extends StatefulWidget {
  const FeedDetailsPage({Key? key}) : super(key: key);

  @override
  _FeedDetailsPageState createState() => _FeedDetailsPageState();
}

class _FeedDetailsPageState extends State<FeedDetailsPage> {
  Map<String, dynamic>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  String timeAgo = '';

  void updateTime() {
    final Duration lastOnline =
        DateTime.now().difference(DateTime.parse(e!.data()['timestamp']));
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    e = data!['e'] as QueryDocumentSnapshot<Map<String, dynamic>>;
    updateTime();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.headline6,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e!.data()['title'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                e!.data()['imageurl'],
                height: 200,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  e!.data()['minidescription'],
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  e!.data()['body'],
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Posted: $timeAgo',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
