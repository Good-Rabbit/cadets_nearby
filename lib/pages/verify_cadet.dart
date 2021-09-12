import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cadets_nearby/data/data.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CadetVerificationPage extends StatefulWidget {
  const CadetVerificationPage({Key? key}) : super(key: key);

  @override
  _CadetVerificationPageState createState() => _CadetVerificationPageState();
}

class _CadetVerificationPageState extends State<CadetVerificationPage> {
  final ImagePicker picker = ImagePicker();

  XFile? image;
  String? stringImage;
  String? filename;

  Future<void> getImage(ImageSource source) async {
    image =
        await picker.pickImage(source: source, imageQuality: 30).then((value) {
      filename = File(value!.path).path.split('/').last;
      stringImage = base64Encode(File(value.path).readAsBytesSync());
      return value;
    });
    setState(() {});
  }

  Future<void> uploadImage() async {
    final Uri uri = Uri.parse('$siteAddress/uploadVp.php');
    http.post(
      uri,
      body: {
        'image': stringImage,
        'name': filename,
      },
    ).then((value) {
      //Update verification requests
      if (value.statusCode == 200) {
        HomeSetterPage.store
            .collection('users')
            .doc(context.read<MainUser>().user!.id)
            .update({
          'verifyurl': '$siteAddress/VPs/${filename!}',
          'verified': 'waiting',
        });
        context.read<MainUser>().user!.verified = 'waiting';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Uploaded Successfully')));
        Navigator.of(context).pop();
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        warnUnverified(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Center(
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
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Submit a document bearing proof that you are a present or an ex cadet. Please note that it might take some time to get verified, you can still use the app while waiting for verification.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
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
                    ElevatedButton.icon(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      icon: const Icon(Icons.photo),
                      label: const Text('Select photo'),
                    ),
                    ElevatedButton.icon(
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  onPressed: image == null
                      ? null
                      : () {
                          uploadImage();
                        },
                  label: const Text('Upload'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    warnUnverified(context);
                  },
                  icon: const Icon(Icons.arrow_left_rounded),
                  label: const Text('Later'),
                ),
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
