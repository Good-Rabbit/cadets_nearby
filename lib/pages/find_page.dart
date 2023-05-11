import 'package:cadets_nearby/data/user.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/no_one_found.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ui_elements/contact_card.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  FindPageState createState() => FindPageState();
}

class FindPageState extends State<FindPage> {
  TextEditingController fullNameTextController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool searched = false;

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Find someone'),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: SizedBox(
                width: 500,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    search();
                  },
                  controller: fullNameTextController,
                  cursorColor: Colors.grey[800],
                  decoration: const InputDecoration(
                    hintText: 'Cadet Name*',
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: Icon(Icons.account_box_rounded),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Cadet name is required';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton.icon(
            onPressed: () {
              search();
            },
            icon: Icon(Icons.search_rounded,
                color: Theme.of(context).primaryColor),
            label: Text(
              'Find',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withAlpha(60),
              ),
            ),
          ),
          if (searched)
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: HomeSetterPage.store
                  .collection('users')
                  .where('cname', isEqualTo: name)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Expanded(child: Center(child: noOneFound(context)));
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: snapshot.data!.docs.map((u) {
                            final AppUser e = AppUser.fromData(u.data());
                            return Container(
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 5.0),
                              child: ContactCard(e: e),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
        ],
      ),
    );
  }

  void search() {
    if (key.currentState!.validate()) {
      name = fullNameTextController.text;
      name = name[0].toUpperCase() + name.substring(1);
      setState(() {
        searched = true;
      });
    }
  }
}
