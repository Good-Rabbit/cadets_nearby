import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/data/appData.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool passwordVisibility = false;
  bool wrongPassword = false;
  bool invalidEmail = false;
  bool userDisabled = false;
  bool userNotFound = false;

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
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
                    child: Text(
                      'to $appName',
                      style: TextStyle(
                        color: Colors.grey[800],
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
                            controller: emailTextController,
                            obscureText: false,
                            cursorColor: Colors.grey[800],
                            onChanged: (val) {
                              if (userDisabled ||
                                  userNotFound ||
                                  invalidEmail) {
                                userDisabled = false;
                                userNotFound = false;
                                invalidEmail = false;
                                checkChanged();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'E-mail',
                              hintStyle: TextStyle(),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                            ),
                            style: TextStyle(),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'E-mail is required';
                              }
                              if (invalidEmail) {
                                return 'Please provide a valid E-mail';
                              }
                              if (userDisabled) {
                                return 'User is disabled';
                              }
                              if (userNotFound) {
                                return 'User not found';
                              }
                              if (!val.contains('@') ||
                                  !val.contains('.') ||
                                  val.endsWith('@') ||
                                  val.endsWith('.')) {
                                return 'Please provide a valid E-mail';
                              }
                              var temp = val;
                              List a = temp.split('@');
                              if (a.length > 2)
                                return 'Please provide a valid E-mail';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
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
                              hintStyle: TextStyle(),
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
                            style: TextStyle(),
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
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.pushNamed(context, '/signup');
                          },
                          label: Text('Register'),
                          icon: Icon(
                            Icons.how_to_reg,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton.icon(
                          onPressed: inProgress
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      inProgress = true;
                                    });
                                    try {
                                      await HomeSetterPage.auth
                                          .signInWithEmailAndPassword(
                                        email: emailTextController.text,
                                        password: passwordTextController.text,
                                      );
                                      // Navigator.of(context).pushReplacementNamed('/');
                                    } on FirebaseAuthException catch (e) {
                                      switch (e.code) {
                                        case 'invalid-email':
                                          invalidEmail = true;
                                          break;
                                        case 'user-disabled':
                                          userDisabled = true;
                                          break;
                                        case 'user-not-found':
                                          userNotFound = true;
                                          break;
                                        case 'wrong-password':
                                          wrongPassword = true;
                                          break;
                                        default:
                                          break;
                                      }
                                      setState(() {
                                        inProgress = false;
                                      });
                                      formKey.currentState!.validate();
                                    }
                                  }
                                },
                          label: Text('Login'),
                          icon: Icon(
                            Icons.login,
                            size: 20,
                          ),
                        )
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                      width: 220,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5.0),
                              width: 25.0,
                              height: 25.0,
                              child: Image.asset('assets/images/google.png',
                                  fit: BoxFit.contain),
                            ),
                            Text('Sign in with Google'),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF1F1F1F)),
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
    return await HomeSetterPage.auth.signInWithCredential(credential);
  }

  checkChanged() {
    formKey.currentState!.validate();
  }
}
