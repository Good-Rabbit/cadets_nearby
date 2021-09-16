import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void signOut() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  googleSignIn.signOut();
  HomeSetterPage.auth.signOut();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  FlutterBackgroundService().sendData({'action': 'stopService'});
  FlutterBackgroundService().stopBackgroundService();
  FlutterBackgroundService().dispose();
}
