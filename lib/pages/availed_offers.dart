import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'home_setter.dart';
import 'ui_elements/availed_card.dart';
import 'ui_elements/loading.dart';

class AvailedOffersPage extends StatefulWidget {
  const AvailedOffersPage({Key? key}) : super(key: key);

  @override
  _AvailedOffersPageState createState() => _AvailedOffersPageState();
}

class _AvailedOffersPageState extends State<AvailedOffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.backpack),
            SizedBox(
              width: 10,
            ),
            Text(
              'Availed Offers',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: HomeSetterPage.store
                .collection('codes')
                .where('id', isEqualTo: context.read<MainUser>().user!.id)
                .get(),
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
                  return Expanded(child: Center(child: noOffersAvailed()));
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
}
