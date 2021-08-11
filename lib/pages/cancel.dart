import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cadets_nearby/data/appData.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';

class CancelVerificationPage extends StatefulWidget {
  CancelVerificationPage({Key? key}) : super(key: key);

  @override
  _CancelVerificationPageState createState() => _CancelVerificationPageState();
}

class _CancelVerificationPageState extends State<CancelVerificationPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool passwordVisibility = false;
  bool wrongPassword = false;

  bool inProgress = false;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Heading
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: Text(
                      'Verify your password',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
                    child: Text(
                      'to delete your account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  //TextFields
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 500,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: passwordTextController,
                            obscureText: !passwordVisibility,
                            cursorColor: Colors.grey[800],
                            onChanged: (val) {
                              if (wrongPassword) {
                                wrongPassword = false;
                                checkChanged();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  Icons.fence_rounded,
                                ),
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () =>
                                      passwordVisibility = !passwordVisibility,
                                ),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Color(0xFF757575),
                                  size: 22,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: (val) {
                              if (wrongPassword) {
                                return 'Password is wrong';
                              }
                              if (val!.isEmpty) {
                                return 'Password is required';
                              }
                              if (val.length < 6) {
                                return 'Password must be 6 characters at least';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Normal Buttons
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text('Cancel'),
                          icon: Icon(
                            Icons.arrow_left_rounded,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: inProgress
                              ? null
                              : () async {
                                  setState(() {
                                    inProgress = true;
                                  });
                                  if (formKey.currentState!.validate()) {
                                    var credential =
                                        EmailAuthProvider.credential(
                                      email: FirebaseAuth
                                          .instance.currentUser!.email!,
                                      password: passwordTextController.text,
                                    );
                                    try {
                                      await HomeSetterPage.auth.currentUser!
                                          .reauthenticateWithCredential(
                                              credential);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'wrong-password') {
                                        wrongPassword = true;
                                      }
                                      formKey.currentState!.validate();
                                      setState(() {
                                        inProgress = false;
                                      });
                                      return;
                                    }
                                    HomeSetterPage.auth.currentUser!
                                        .delete()
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Account has been deleted'),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    });
                                  }
                                  setState(() {
                                    inProgress = false;
                                  });
                                },
                          label: Text('Confirm'),
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                      child: Text('Forgot password?'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reset');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkChanged() {
    formKey.currentState!.validate();
  }
}
