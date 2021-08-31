import 'package:flutter/material.dart';
import 'package:cadets_nearby/pages/home_setter.dart';

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
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Text(
              'Reset password',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
            child: Text(
              'An e-mail with the password reset link will be sent to you. Please follow the instructions given in the e-mail to reset your password',
              maxLines: 5,
              style: TextStyle(
                color: Colors.grey[800],
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
                    cursorColor: Colors.grey[800],
                    // onChanged: (val) {
                    //   if (userDisabled || userNotFound || invalidEmail) {
                    //     userDisabled = false;
                    //     userNotFound = false;
                    //     invalidEmail = false;
                    //     checkChanged();
                    //   }
                    // },
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
                      final temp = val;
                      final List a = temp.split('@');
                      if (a.length > 2) return 'Please provide a valid E-mail';
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
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
                            Theme.of(context).accentColor),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        HomeSetterPage.auth
                            .sendPasswordResetEmail(
                                email: emailTextController.text)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reset E-mail sent'),
                            ),
                          );
                          Navigator.pop(context);
                        });
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Send E-mail'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void checkChanged() {
    formKey.currentState!.validate();
  }
}
