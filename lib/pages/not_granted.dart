import 'package:cadets_nearby/services/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotGranted extends StatefulWidget {
  const NotGranted({Key? key}) : super(key: key);

  @override
  _NotGrantedState createState() => _NotGrantedState();
}

class _NotGrantedState extends State<NotGranted> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                      Icons.warning_rounded,
                      size: 100,
                      color: Colors.red,
                    ),
                  const SizedBox(height: 30),
                  Text(
                    !context.read<LocationStatus>().serviceEnabled
                        ? 'Location Disabled'
                        : 'Location permission not granted',
                        textAlign:TextAlign.center,
                    style: const TextStyle(fontSize: 25,),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        context.read<LocationStatus>().getPermissions();
                      },
                      child: Text(
                        !context.read<LocationStatus>().serviceEnabled
                            ? 'Enable Location'
                            : 'Grant permission',
                        textAlign:TextAlign.center,

                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
