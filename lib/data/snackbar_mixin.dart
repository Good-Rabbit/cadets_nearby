import 'package:flutter/material.dart';

mixin AsyncSnackbar<T extends StatefulWidget> on State<T> {
  showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
