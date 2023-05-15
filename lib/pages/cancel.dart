import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelVerificationPage extends StatefulWidget {
  const CancelVerificationPage({Key? key}) : super(key: key);

  @override
  CancelVerificationPageState createState() => CancelVerificationPageState();
}

class CancelVerificationPageState extends State<CancelVerificationPage> {
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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  //Heading
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: Text(
                      'Verify your password',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                    child: Text(
                      'to delete your account',
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  ),
                  //TextFields
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: SizedBox(
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
                              labelText: 'Password',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
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
                                  color: const Color(0xFF757575),
                                  size: 22,
                                ),
                              ),
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
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: const Text('Cancel'),
                          icon: const Icon(
                            Icons.arrow_left_rounded,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: inProgress
                              ? null
                              : () async {
                                  setState(() {
                                    inProgress = true;
                                  });
                                  if (formKey.currentState!.validate()) {
                                    final credential =
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
                                    await HomeSetterPage.auth.currentUser!
                                        .delete()
                                        .then((value) async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Account has been deleted'),
                                        ),
                                      );
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    });
                                  }
                                  setState(() {
                                    inProgress = false;
                                  });
                                },
                          label: const Text('Confirm'),
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                    child: FilledButton(
                      onPressed: () async {
                        // Trigger the authentication flow
                        final GoogleSignInAccount googleUser =
                            (await GoogleSignIn().signIn())!;

                        // Obtain the auth details from the request
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;

                        // Create a new credential
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        try {
                          await HomeSetterPage.auth.currentUser!
                              .reauthenticateWithCredential(credential);
                        } on FirebaseAuthException catch (_) {}
                        HomeSetterPage.auth.currentUser!
                            .delete()
                            .then((value) async {
                          final googleSignIn = GoogleSignIn();
                          googleSignIn.signOut();
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account has been deleted'),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          setState(() {
                            inProgress = false;
                          });
                          return;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF1F1F1F)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            width: 25.0,
                            height: 25.0,
                            child: Image.asset('assets/images/google.png',
                                fit: BoxFit.contain),
                          ),
                          const Text('Signed in with Google?'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reset');
                      },
                      child: const Text('Forgot password?'),
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

  void checkChanged() {
    formKey.currentState!.validate();
  }
}
