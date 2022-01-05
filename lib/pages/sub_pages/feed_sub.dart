import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/feed_card.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedSubPage extends StatefulWidget {
  const FeedSubPage({Key? key}) : super(key: key);

  @override
  _FeedSubPageState createState() => _FeedSubPageState();
}

class _FeedSubPageState extends State<FeedSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int limit = 10;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Feed',
              style: TextStyle(fontSize: 25),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('feed')
                .orderBy('timestamp', descending: true)
                .limitToLast(limit)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data!.docs.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...snapshots.data!.docs.map((e) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: FeedCard(e: e),
                          );
                        }),
                      ],
                    ),
                  );
                } else {
                  return nothingToShow();
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget nothingToShow() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.feed_rounded,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Nothing to show',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
