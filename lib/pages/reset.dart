import 'package:flutter/material.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();

  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Text(
              'Reset password',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
            child: Text(
              'An e-mail with the password reset link will be sent to you. Please follow the instructions given in the e-mail to reset your password',
              maxLines: 5,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailTextController,
                    obscureText: false,
                    cursorColor: Colors.grey[800],
                    // onChanged: (val) {
                    //   if (userDisabled || userNotFound || invalidEmail) {
                    //     userDisabled = false;
                    //     userNotFound = false;
                    //     invalidEmail = false;
                    //     checkChanged();
                    //   }
                    // },
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
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'E-mail is required';
                      }
                      // if (invalidEmail) {
                      //   return 'Please provide a valid E-mail';
                      // }
                      // if (userDisabled) {
                      //   return 'User is disabled';
                      // }
                      // if (userNotFound) {
                      //   return 'User not found';
                      // }
                      if (!val.contains('@') ||
                          !val.contains('.') ||
                          val.endsWith('@') ||
                          val.endsWith('.')) {
                        return 'Please provide a valid E-mail';
                      }
                      var temp = val;
                      List a = temp.split('@');
                      if (a.length > 2) return 'Please provide a valid E-mail';
                      return null;
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    HomeSetterPage.auth
                        .sendPasswordResetEmail(email: emailTextController.text)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reset E-mail sent'),
                        ),
                      );
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(Icons.login),
                  label: Text('Send E-mail'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  checkChanged() {
    formKey.currentState!.validate();
  }
}
