import 'dart:developer';

import 'package:cadets_nearby/data/app_data.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupMainPage extends StatefulWidget {
  const SignupMainPage({Key? key}) : super(key: key);

  @override
  SignupMainPageState createState() => SignupMainPageState();
}

class SignupMainPageState extends State<SignupMainPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmTextController = TextEditingController();

  bool passwordVisibility = false;
  bool emailInUse = false;
  bool invalidEmail = false;
  bool notAllowed = false;
  bool weakPassword = false;

  bool inProgress = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                      child: Text(
                        'at $appName',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: SizedBox(
                        width: 500,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailTextController,
                              cursorColor: Colors.grey[800],
                              decoration: const InputDecoration(
                                hintText: 'E-mail',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) {
                                if (invalidEmail || emailInUse) {
                                  invalidEmail = false;
                                  emailInUse = false;
                                  checkChanged();
                                }
                              },
                              validator: (val) {
                                if (emailInUse) {
                                  return 'E-mail is already in use';
                                }
                                if (invalidEmail) {
                                  return 'Please provide a valid E-mail';
                                }
                                if (val!.isEmpty) {
                                  return 'E-mail is required';
                                }
                                if (!val.contains('@') ||
                                    !val.contains('.') ||
                                    val.endsWith('@') ||
                                    val.endsWith('.')) {
                                  return 'Please provide a valid E-mail';
                                }
                                final temp = val;
                                final List a = temp.split('@');
                                if (a.length > 2) {
                                  return 'Please provide a valid E-mail';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: passwordTextController,
                              obscureText: !passwordVisibility,
                              cursorColor: Colors.grey[800],
                              onChanged: (val) {
                                if (weakPassword) {
                                  weakPassword = false;
                                  checkChanged();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Icon(
                                    Icons.fence_rounded,
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility =
                                        !passwordVisibility,
                                  ),
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF757575),
                                    size: 22,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (val) {
                                if (weakPassword) {
                                  return 'Password is weak';
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
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: confirmTextController,
                              obscureText: !passwordVisibility,
                              cursorColor: Colors.grey[800],
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Icon(
                                    Icons.fence_rounded,
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility =
                                        !passwordVisibility,
                                  ),
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF757575),
                                    size: 22,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (val) {
                                if (val != passwordTextController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: const Text('Login'),
                            icon: const Icon(
                              Icons.login,
                              size: 20,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          ElevatedButton.icon(
                            onPressed: inProgress
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        inProgress = true;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: SafeArea(
                                          child: Text('Creating account'),
                                        ),
                                      ));
                                      HomeSetterPage.auth
                                          .createUserWithEmailAndPassword(
                                        email: emailTextController.text,
                                        password: passwordTextController.text,
                                      )
                                          .onError<FirebaseAuthException>(
                                              (e, stackTrace) {
                                        log(e.code);
                                        switch (e.code) {
                                          case 'email-already-in-use':
                                            emailInUse = true;
                                            break;
                                          case 'invalid-email':
                                            invalidEmail = true;
                                            break;
                                          case 'operation-not-allowed':
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Please try again'),
                                              ),
                                            );
                                            break;
                                          case 'weak-password':
                                            weakPassword = true;
                                            break;
                                          default:
                                            break;
                                        }
                                        setState(() {
                                          inProgress = false;
                                        });
                                        checkChanged();
                                        throw FirebaseAuthException;
                                      }).then((value) {
                                        HomeSetterPage.auth.currentUser!
                                            .sendEmailVerification();
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                            label: const Text('Register'),
                            icon: const Icon(
                              Icons.how_to_reg,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: 220,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            signInWithGoogle();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF1F1F1F)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                width: 25.0,
                                height: 25.0,
                                child: Image.asset('assets/images/google.png',
                                    fit: BoxFit.contain),
                              ),
                              const Text('Sign in with Google'),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return HomeSetterPage.auth.signInWithCredential(credential).then((value) {
      Navigator.of(context).pop();
      return value;
    });
  }

  void checkChanged() {
    formKey.currentState!.validate();
  }
}
