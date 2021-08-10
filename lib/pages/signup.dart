import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readiew/data/appData.dart';
import 'package:readiew/pages/homeSetter.dart';

class SignupMainPage extends StatefulWidget {
  SignupMainPage({Key? key}) : super(key: key);

  @override
  _SignupMainPageState createState() => _SignupMainPageState();
}

class _SignupMainPageState extends State<SignupMainPage> {
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
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: Text(
                      'Sign Up',
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
                      'at $appName',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
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
                            decoration: InputDecoration(
                              hintText: 'E-mail',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
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
                              if (weakPassword) {
                                weakPassword = false;
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
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: confirmTextController,
                            obscureText: !passwordVisibility,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
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
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text('Login'),
                          icon: Icon(
                            Icons.login,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            elevation: MaterialStateProperty.all(0),
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
                                          .createUserWithEmailAndPassword(
                                        email: emailTextController.text,
                                        password: passwordTextController.text,
                                      )
                                          .then((value) {
                                        HomeSetterPage.auth.currentUser!
                                            .sendEmailVerification();
                                        Navigator.of(context).pop();
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      print(e);
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
                                            SnackBar(
                                              content: Text('Please try again'),
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
                                    }
                                  }
                                },
                          label: Text('Register'),
                          icon: Icon(
                            Icons.how_to_reg,
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
                          textStyle: MaterialStateProperty.all(
                            GoogleFonts.getFont(
                              'Roboto',
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
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
    return await HomeSetterPage.auth
        .signInWithCredential(credential)
        .then((value) {
      Navigator.of(context).pop();
      return value;
    });
  }

  checkChanged() {
    formKey.currentState!.validate();
  }
}
