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

class CadetVerificationPage extends StatefulWidget {
  const CadetVerificationPage({Key? key}) : super(key: key);

  @override
  CadetVerificationPageState createState() => CadetVerificationPageState();
}

class CadetVerificationPageState extends State<CadetVerificationPage>
    with AsyncSnackbar {
  final ImagePicker picker = ImagePicker();

  XFile? image;
  String? stringImage;
  String? filename;
  String? id;

  @override
  initState() {
    super.initState();
    id = context.read<MainUser>().user!.id;
  }

  Future<void> getImage(ImageSource source) async {
    image =
        await picker.pickImage(source: source, imageQuality: 25).then((value) {
      filename = File(value!.path).path.split('/').last;
      stringImage = base64Encode(File(value.path).readAsBytesSync());
      return value;
    });
    setState(() {});
  }

  uploadImage() {
    showSnackbar('Uploading Image');
    FirebaseStorage.instance
        .ref('VPs/$filename')
        .putString(stringImage!, format: PutStringFormat.base64)
        .then((value) async {
      final String url =
          await FirebaseStorage.instance.ref('VPs/$filename').getDownloadURL();
      //Update verification requests
      HomeSetterPage.store.collection('users').doc(id).update({
        'verifyurl': url,
        'verified': 'waiting',
      });
      // context.read<MainUser>().user!.verified = 'waiting';
      showSnackbar('Uploaded Successfully');
    }).catchError((e) {
      log(e.toString());
    }).then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        warnUnverified(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Hero(
                  tag: 'warningHero',
                  child: Icon(
                    Icons.warning_rounded,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  'Document verification',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                  child: Text(
                    'Submit a document bearing proof that you are a present or an ex cadet. Please note that it might take some time to get verified, you can still use the app while waiting for verification. e.g.-',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '• Cadet ID card',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '• Pic in cadet uniform',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '• Something like that',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                  child: Text(
                    'P.S.- DO NOT SUBMIT ANYTHING THAT CAN\'T PROVE THAT YOU ARE A CADET. YOUR ACCOUNT MIGHT BE DELETED. CONTACT US IF YOU DON\'T HAVE ANYTHING.',
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                  ),
                  width: 300,
                  height: 200,
                  child: image != null
                      ? Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Select an image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      icon: const Icon(Icons.photo),
                      label: const Text('Select photo'),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      icon: const Icon(Icons.camera),
                      label: const Text('Take photo'),
                    ),
                  ],
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.upload),
                  onPressed: image == null
                      ? null
                      : () {
                          uploadImage();
                        },
                  label: const Text('Upload'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    warnUnverified(context);
                  },
                  icon: const Icon(Icons.arrow_left_rounded),
                  label: const Text('Later'),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> warnUnverified(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: 500,
        child: AlertDialog(
          title: const Text('Are you sure'),
          content: const Text(
            'Your account will be marked as unverified until you upload a valid document of proof.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        ),
      ),
    );
  }
}
