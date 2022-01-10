import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  bool warningGiven = false;

  giveWarning() {
    warningGiven = true;
  }
}
