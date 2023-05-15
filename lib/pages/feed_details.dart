import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedDetailsPage extends StatefulWidget {
  const FeedDetailsPage({Key? key}) : super(key: key);

  @override
  FeedDetailsPageState createState() => FeedDetailsPageState();
}

class FeedDetailsPageState extends State<FeedDetailsPage> {
  Map<String, dynamic>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? e;
  String timeAgo = '';

  void updateTime() {
    final Duration postTime =
        DateTime.now().difference(DateTime.parse(e!.data()['timestamp']));
    if (postTime.inSeconds <= 20) {
      timeAgo = 'Just now';
    } else if (postTime.inMinutes < 60) {
      timeAgo = '${postTime.inMinutes} mins ago';
    } else if (postTime.inHours < 24) {
      timeAgo = '${postTime.inHours} hrs ago';
    } else if (postTime.inHours < 47) {
      timeAgo = 'Yesterday';
    } else if (postTime.inDays < 30) {
      timeAgo = '${postTime.inDays} days ago';
    } else if (postTime.inDays < 365) {
      timeAgo =
          '${(postTime.inDays / 30).floor()} ${(postTime.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else {
      int years = (postTime.inDays ~/ 365);
      timeAgo = '$years ${years == 1 ? 'year' : 'years'} ago';
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e!.data()['title'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  e!.data()['minidescription'],
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  e!.data()['body'],
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Posted: $timeAgo',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
