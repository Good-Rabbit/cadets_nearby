import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Center(
        child: SpinKitFadingCube(
          color: Theme.of(context).accentColor,
          duration: const Duration(seconds: 1),
        ),
      ),
    );
  }
}
