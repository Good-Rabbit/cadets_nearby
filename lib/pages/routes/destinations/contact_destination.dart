import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/contact_card.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactSubPage extends StatefulWidget {
  const ContactSubPage({Key? key}) : super(key: key);

  @override
  ContactSubPageState createState() => ContactSubPageState();
}

class ContactSubPageState extends State<ContactSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Contacts',
              style: TextStyle(fontSize: 25.0),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/find');
              },
              icon: Icon(Icons.search_rounded,
                  color: Theme.of(context).colorScheme.primary),
              label: Text(
                'Find someone',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary.withAlpha(60),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: HomeSetterPage.store
                  .collection('users')
                  .where('contact', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  if (snapshots.data!.docs.isEmpty) {
                    return Expanded(child: Center(child: noContacts(context)));
                  } else {
                    return Expanded(
                      child: ListView(
                        children: snapshots.data!.docs.map((u) {
                          final AppUser e = AppUser.fromData(u.data());
                          return Container(
                            margin:
                                const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: ContactCard(e: e),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }
                return const Expanded(child: Center(child: Loading()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget noContacts(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.no_cell,
          size: 70.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          'No contacts',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
