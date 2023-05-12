import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

sendReportWithStackTrace({required StackTrace stackTrace, required context}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Send error report?'),
      content: const Text(
          'There was an error. Would you like to report this via e-mail?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),
        TextButton(
            onPressed: () {
              launchUrl(
                Uri.parse(
                    'mailto:cadetsnearby@gmail.com?subject=Error report uid/${HomeSetterPage.auth.currentUser!.uid}&body=${stackTrace.toString()}'),
              );
            },
            child: const Text('Yes'))
      ],
    ),
  );
}
