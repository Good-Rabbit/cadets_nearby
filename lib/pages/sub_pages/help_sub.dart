import 'dart:ui';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/support_card.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AboutSubPage extends StatefulWidget {
  const AboutSubPage({Key? key}) : super(key: key);

  @override
  _AboutSubPageState createState() => _AboutSubPageState();
}

class _AboutSubPageState extends State<AboutSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'We are here to help',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(300, 60),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/posthelp');
                },
                icon: const Icon(Icons.support),
                label: const Text('Ask for help')),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('support')
                .where('id', isEqualTo: context.read<MainUser>().user!.id)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data!.docs.isNotEmpty) {
                  return Column(
                    children: [
                      const Text(
                        'Support requested by you',
                        style: TextStyle(fontSize: 20),
                      ),
                      ...snapshots.data!.docs.map((e) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: SupportCard(e: e),
                        );
                      }),
                      const SizedBox(height: 20,),
                    ],
                  );
                }
              }
              return const SizedBox();
            },
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('support')
                .where('id', isNotEqualTo: context.read<MainUser>().user!.id)
                .where('status', whereIn: ['waiting','emergency'],)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data!.docs.isNotEmpty) {
                  return Column(
                    children: [
                      const Text(
                        'Support requested by others',
                        style: TextStyle(fontSize: 20),
                      ),
                      ...snapshots.data!.docs.map((e) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: SupportCard(e: e),
                        );
                      }),
                    ],
                  );
                }else{
                  return noSupportNeeded();
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget noSupportNeeded() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1 / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.support,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            "No support needed",
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
