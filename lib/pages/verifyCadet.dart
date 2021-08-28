import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cadets_nearby/data/data.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  getImage(source) async {
    image =
        await picker.pickImage(source: source, imageQuality: 30).then((value) {
      filename = File(value!.path).path.split('/').last;
      stringImage = base64Encode(File(value.path).readAsBytesSync());
      return value;
    });
    setState(() {});
  }

  uploadImage() async {
    Uri uri = Uri.parse(siteAddress + '/uploadVp.php');
    http.post(
      uri,
      body: {
        'image': stringImage,
        'name': filename,
      },
    ).then((value) {
      //Update verification requests
      if (value.statusCode == 200) {
        print(value.body);
        HomeSetterPage.store
            .collection('users')
            .doc(HomeSetterPage.mainUser!.id)
            .update({
          'verifyurl': siteAddress + '/VPs/' + filename!,
          'verified': 'waiting',
        });
        HomeSetterPage.mainUser!.verified = 'waiting';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Uploaded Successfully')));
        Navigator.of(context).pop();
      } else {
        print(value.body);
      }
    }).catchError((e) {
      print(e);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'warningHero',
                  child: Icon(
                    Icons.warning_rounded,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Document verification',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
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
                      : Center(
                          child: Text(
                            'Select an image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
                SizedBox(
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
                      icon: Icon(Icons.photo),
                      label: Text('Select photo'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      icon: Icon(Icons.camera),
                      label: Text('Take photo'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: image == null
                      ? null
                      : () {
                          uploadImage();
                        },
                  child: Text('Upload'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    warnUnverified(context);
                  },
                  icon: Icon(Icons.arrow_left_rounded),
                  label: Text('Later'),
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
      builder: (context) => Container(
        width: 500,
        child: AlertDialog(
          title: Text('Are you sure'),
          content: Text(
            'Your account will be marked as unverified until you upload a valid document of proof.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        ),
      ),
    );
  }
}
