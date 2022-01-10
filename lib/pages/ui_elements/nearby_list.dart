import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/loading.dart';
import 'package:cadets_nearby/pages/ui_elements/people_list.dart';
import 'package:cadets_nearby/services/location_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/settings_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyList extends StatelessWidget {
  const NearbyList({Key? key}) : super(key: key);


void getLocation(BuildContext context) async {
      if (context.read<LocationStatus>().locationData != null) {
        return;
      }

      await context.read<LocationStatus>().getLocation();
      return;
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<LocationStatus>().permissionGranted &&
        context.read<LocationStatus>().serviceEnabled
        ) {
      getLocation(context);
    }

    if (context.read<MainUser>().user!.verified == 'no' && !context.read<AppSettings>().warningGiven) {
      context.read<AppSettings>().giveWarning();
      Future.delayed(const Duration(seconds: 5)).then((value) {
        Navigator.of(context).pushNamed('/verification');
      });
    }

    return Column(
      children: [
        if (context.watch<LocationStatus>().locationData != null &&
            !(!context.read<LocationStatus>().serviceEnabled ||
                !context.read<LocationStatus>().permissionGranted))
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: HomeSetterPage.store
                .collection('users')
                .where('lat',
                    isLessThan: context.read<LocationStatus>().latMax,
                    isGreaterThan: context.read<LocationStatus>().latMin)
                .where('sector', whereIn: [
              context.read<MainUser>().user!.sector + 3,
              context.read<MainUser>().user!.sector + 2,
              context.read<MainUser>().user!.sector + 1,
              context.read<MainUser>().user!.sector,
              context.read<MainUser>().user!.sector - 1,
              context.read<MainUser>().user!.sector - 2,
              context.read<MainUser>().user!.sector - 3,
            ]).snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return PeopleList(docs: snapshots.data!.docs);
              }
              return const Expanded(child: Loading());
            },
          ),
        if (!context.read<LocationStatus>().serviceEnabled ||
            !context.read<LocationStatus>().permissionGranted)
          Expanded(child: locationDisabled(context)),
        if (context.read<LocationStatus>().locationData == null &&
            context.read<LocationStatus>().permissionGranted &&
            context.read<LocationStatus>().serviceEnabled)
          const Expanded(child: Loading()),
      ],
    );
  }

  // Widget noOneNearby() {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 3 / 4,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       children: [
  //         Icon(
  //           Icons.no_accounts,
  //           size: 70.0,
  //           color: Theme.of(context).primaryColor,
  //         ),
  //         Text(
  //           'No one nearby',
  //           style: TextStyle(
  //             fontSize: 25,
  //             color: Theme.of(context).primaryColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget locationDisabled(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_disabled,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Location Disabled',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
