import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  bool _warningGiven = false;

  bool get warningGiven => _warningGiven;

  set warningGiven(bool warningGiven) {
    _warningGiven = warningGiven;
  }

  giveWarning() {
    warningGiven = true;
  }
}
