import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PostHelpPage extends StatefulWidget {
  const PostHelpPage({Key? key}) : super(key: key);

  @override
  _PostHelpPageState createState() => _PostHelpPageState();
}

class _PostHelpPageState extends State<PostHelpPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool fromAccount = true;
  bool emergency = false;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    phoneController.dispose();
    bodyController.dispose();
    formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (context.read<MainUser>().user!.phone == '') {
      fromAccount = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fromAccount) {
      phoneController.text = context.read<MainUser>().user!.phone;
    } else {
      phoneController.text = '';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.support),
            SizedBox(
              width: 10,
            ),
            Text(
              'Enter your details',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Text(
                    'Please don\'t misuse the emergency button and make it unusable',
                    maxLines: 2,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                  child: SizedBox(
                    width: 500,
                    child: CheckboxListTile(
                        value: emergency,
                        title: const Text(
                          'EMERGENCY!',
                        ),
                        subtitle: const Text(
                            'This will bypass verification, but will be reviewed later.'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            emergency = value!;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      controller: titleController,
                      cursorColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        hintText: 'Title*',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Icon(Icons.title),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val == '') {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      maxLines: 6,
                      maxLength: 1000,
                      controller: bodyController,
                      cursorColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        hintText: 'Description*',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Icon(Icons.description),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val == '') {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      controller: phoneController,
                      enabled: !fromAccount,
                      cursorColor: Colors.grey[800],
                      decoration: const InputDecoration(
                        hintText: 'Phone*',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Icon(Icons.phone),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val == '') {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                if (context.watch<MainUser>().user!.phone != '')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: SizedBox(
                      width: 500,
                      child: CheckboxListTile(
                          value: fromAccount,
                          title: const Text(
                            'Use account phone',
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          activeColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              fromAccount = value!;
                            });
                          }),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final mainContext = context;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Is the information correct?'),
                              content: Text(emergency
                                  ? 'Post for help directly'
                                  : 'Post for review'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No, go back.')),
                                TextButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Uploading post'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );

                                      if (await uploadPost(context)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Successfully posted'),
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                        Navigator.of(mainContext).pop();
                                      }
                                    },
                                    child: const Text('Yes.')),
                              ],
                            );
                          });
                    }
                  },
                  icon: const Icon(Icons.arrow_right_rounded),
                  label: const Text('Submit'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> uploadPost(BuildContext context) async {
    try {
      await HomeSetterPage.store.collection('support').add({
        'id': context.read<MainUser>().user!.id,
        'title': titleController.text,
        'body': bodyController.text,
        'phone': phoneController.text,
        'lat': context.read<MainUser>().user!.lat,
        'long': context.read<MainUser>().user!.long,
        'emergency': emergency,
        'status': emergency ? 'emergency' : 'waiting',
        'timestamp': DateTime.now().toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
