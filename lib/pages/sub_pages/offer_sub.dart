import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/offer_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferSubPage extends StatefulWidget {
  const OfferSubPage({Key? key}) : super(key: key);

  @override
  _OfferSubPageState createState() => _OfferSubPageState();
}

class _OfferSubPageState extends State<OfferSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 40,
              ),
              const Text(
                'Ongoing offers',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/availedoffers');
                  },
                  icon: Icon(
                    Icons.backpack_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store.collection('offers').snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ...snapshots.data!.docs.map((e) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: OfferCard(e: e),
                          );
                        }),
                      ],
                    ),
                  );
                } else {
                  return noOffersOngoing();
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget noOffersOngoing() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1 / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.backpack,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'No offers ongoing',
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
