import 'package:cadets_nearby/main.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_setter.dart';
import '../../ui_elements/availed_card.dart';
import '../../ui_elements/loading.dart';

class AvailedOffersPage extends StatefulWidget {
  const AvailedOffersPage({Key? key}) : super(key: key);

  @override
  AvailedOffersPageState createState() => AvailedOffersPageState();
}

class AvailedOffersPageState extends State<AvailedOffersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.backpack_rounded),
            SizedBox(
              width: 10,
            ),
            Text(
              'Availed Offers',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('codes')
                .where('id', isEqualTo: context.read<MainUser>().user!.id)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: [
                        ...snapshots.data!.docs.map((e) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: AvailedCard(e: e),
                          );
                        }),
                      ],
                    ),
                  );
                } else {
                  return Expanded(child: noOffersAvailed());
                }
              }
              return const Expanded(child: Loading());
            },
          ),
        ],
      ),
    );
  }

  Widget noOffersAvailed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.backpack,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'No offers availed',
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
