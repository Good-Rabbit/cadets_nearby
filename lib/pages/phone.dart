import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readiew/pages/homeSetter.dart';

class PhonePage extends StatefulWidget {
  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  bool passwordVisibility = false;

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  color: Color(0xFFFFEED2),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                      child: Text(
                        'Add a phone',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        '- Optional',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Container(
                        width: 500,
                        child: TextFormField(
                          controller: emailTextController,
                          obscureText: false,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (val) {
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
                      ),
                    ),
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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                try {
                                  HomeSetterPage.auth
                                      .signInWithEmailAndPassword(
                                          email: emailTextController.text,
                                          password:
                                              passwordTextController.text);
                                } on FirebaseAuthException catch (e) {
                                  print(e.code);
                                }
                              }
                            },
                            label: Text('Login'),
                            icon: Icon(
                              Icons.login,
                              size: 20,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                          )
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
                            //TODO: GOOGLE SIGN IN
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
