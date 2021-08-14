import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:cadets_nearby/pages/uiElements/loading.dart';
import 'package:cadets_nearby/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserMessagePage extends StatefulWidget {
  UserMessagePage({Key? key}) : super(key: key);

  @override
  _UserMessagePageState createState() => _UserMessagePageState();
}

class _UserMessagePageState extends State<UserMessagePage> {
  TextEditingController messageController = TextEditingController();
  bool newChat = false;
  AppUser? user;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as AppUser;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(user!.cName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('messages')
                .doc(HomeSetterPage.mainUser!.id)
                .collection('all')
                .where(
                  'id',
                  isEqualTo: user!.id,
                )
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.active ||
                  snapshots.connectionState == ConnectionState.done) {
                if (!snapshots.hasData) {
                  newChat = true;
                  return Center(
                    child: Text('Something went wrong!'),
                  );
                } else if (snapshots.data!.docs.isEmpty) {
                  newChat = true;
                  return Center(
                    child: Text('No chat history'),
                  );
                }
                List<Map<String, dynamic>> messages =
                    snapshots.data!.docs.map((e) => e.data()).toList();
                messages.sort((a, b) {
                  DateTime t1 = DateTime.parse(a['time']);
                  DateTime t2 = DateTime.parse(b['time']);
                  return t2.compareTo(t1);
                });
                return ListView(
                  reverse: true,
                  children: messages.map((e) => showMessage(e)).toList(),
                );
              }
              return Center(child: Loading());
            },
          )),
          Container(
            color: Theme.of(context).primaryColor,
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        sendMessage(value);
                      },
                      style: TextStyle(fontSize: 15),
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'Type Your Message',
                        fillColor: Colors.orange[50],
                      ),
                      controller: messageController,
                      cursorColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(messageController.text);
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.orange[50],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showMessage(Map<String, dynamic> e) {
    const edgeInsets = const EdgeInsets.fromLTRB(15, 10, 15, 10);
    if (e['sent']) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
              child: Padding(
            padding: edgeInsets,
            child: Text(e['message']),
          )),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
              child: Padding(
            padding: edgeInsets,
            child: Text(e['message']),
          )),
        ],
      );
    }
  }

  void sendMessage(String value) async {
    try {
      if (newChat) {
        await HomeSetterPage.store
            .collection('users')
            .doc(HomeSetterPage.mainUser!.id)
            .collection('chats')
            .doc(user!.id)
            .set({'chatted': true});
        await HomeSetterPage.store
            .collection('users')
            .doc(user!.id)
            .collection('chats')
            .doc(HomeSetterPage.mainUser!.id)
            .set({'chatted': true});
      }
      await HomeSetterPage.store
          .collection('messages')
          .doc(HomeSetterPage.mainUser!.id)
          .collection('all')
          .doc()
          .set({
        'id': user!.id,
        'sent': true,
        'message': value,
        'time': DateTime.now().toString(),
      });
      messageController.text = '';
      await HomeSetterPage.store
          .collection('messages')
          .doc(user!.id)
          .collection('all')
          .doc()
          .set({
        'id': HomeSetterPage.mainUser!.id,
        'sent': false,
        'message': value,
        'time': DateTime.now().toString(),
      });
    } catch (e) {
      print(e);
    }
  }
}
