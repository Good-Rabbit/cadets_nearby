import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/snackbar_mixin.dart';

class DpPage extends StatefulWidget {
  const DpPage({Key? key}) : super(key: key);

  @override
  DpPageState createState() => DpPageState();
}

class DpPageState extends State<DpPage> with AsyncSnackbar {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? stringImage;
  String? filename;
  String? id;

  Future<void> getImage(ImageSource source) async {
    image = await picker
        .pickImage(
      source: source,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.front,
    )
        .then((value) {
      filename = File(value!.path).path.split('/').last;
      stringImage = base64Encode(File(value.path).readAsBytesSync());
      return value;
    });
    setState(() {});
  }

  Future<void> uploadImage() async {
    FirebaseStorage.instance
        .ref('DPs/$filename')
        .putString(stringImage!, format: PutStringFormat.base64)
        .then((value) async {
      //!Delete previous if manual
      if (context.read<MainUser>().user!.manualDp) {
        FirebaseStorage.instance
            .refFromURL(context.read<MainUser>().user!.photoUrl)
            .delete();
      }
      //!Update account
      final String url =
          await FirebaseStorage.instance.ref('DPs/$filename').getDownloadURL();
      HomeSetterPage.store.collection('users').doc(id).update({
        'photourl': url,
        'manualdp': true,
      });
      showSnackbar('Updated Successfully');
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> deleteImage() async {
    FirebaseStorage.instance
        .refFromURL(context.read<MainUser>().user!.photoUrl)
        .delete()
        .then((value) {
      //!Update account
      HomeSetterPage.store
          .collection('users')
          .doc(id)
          .update({
        'photourl': '',
        'manualdp': false,
      });
      showSnackbar('Deleted Successfully');
      Navigator.of(context).pop();
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    id = context.read<MainUser>().user!.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Change profile picture',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: image != null
                          ? Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            )
                          : (context.read<MainUser>().user!.photoUrl == ''
                              ? Image.asset(
                                  'assets/images/user.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  context.read<MainUser>().user!.photoUrl,
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Your profile picture is always visible to everyone. You cannot change that. But you can always delete your profile picture',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        label: const Text('Take picture'),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        label: const Text('Select picture'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        onPressed: !context.read<MainUser>().user!.manualDp
                            ? null
                            : () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Are you sure?'),
                                        content: const Text(
                                            'Your profile picture will be permanently deleted'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteImage();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.error),
                        ),
                        label: const Text('Delete picture'),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload),
                        onPressed: image == null
                            ? null
                            : () {
                                Future.delayed(Duration.zero, uploadImage).then(
                                    (value) => Navigator.of(context).pop());
                              },
                        label: const Text('Upload picture'),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_left_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
