import 'dart:convert';
import 'dart:io';

import 'package:cadets_nearby/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DpPage extends StatefulWidget {
  const DpPage({Key? key}) : super(key: key);

  @override
  _DpPageState createState() => _DpPageState();
}

class _DpPageState extends State<DpPage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? stringImage;
  String? filename;

  getImage(source) async {
    image = await picker
        .pickImage(
            source: source, maxHeight: 500, maxWidth: 500, imageQuality: 40)
        .then((value) {
      filename = File(value!.path).path.split('/').last;
      stringImage = base64Encode(File(value.path).readAsBytesSync());
      return value;
    });
    setState(() {});
  }

  uploadImage() async {
    Uri uri = Uri.parse(siteAddress + '/upload.php');
    http.post(
      uri,
      body: {
        'image': stringImage,
        'name': filename,
      },
    ).then((value) {
      //Do something
      if (value.statusCode == 200) {
        print(value.body);
        HomeSetterPage.store
            .collection('users')
            .doc(HomeSetterPage.mainUser!.id)
            .update({'photourl': siteAddress + '/DPs/' + filename!});
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Updated Successfully')));
      } else {
        print(value.body);
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(image == null);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Change profile picture',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
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
                          : Image.network(
                              HomeSetterPage.mainUser!.photoUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Your profile picture is always visible to everyone. You cannot change that. But you can always delete your profile picture',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        label: Text('Take picture'),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.photo),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        label: Text('Select picture'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: image == null
                        ? null
                        : () async {
                            uploadImage();
                          },
                    child: Text('Upload picture'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
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
