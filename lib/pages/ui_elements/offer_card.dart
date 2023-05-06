import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferCard extends StatefulWidget {
  const OfferCard({
    Key? key,
    required this.e,
    required this.distanceM,
  }) : super(key: key);

  final Map<String, dynamic> e;
  final int distanceM;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    
    bool isKm = false;
    double distanceKm = 0;
    int distanceM = widget.distanceM;
    if (widget.distanceM > 1000) {
      isKm = true;
      distanceKm = (widget.distanceM - widget.distanceM % 10)/1000;
      distanceKm = double.parse(distanceKm.toStringAsFixed(2));
    } else if (widget.distanceM >= 10) {
      distanceM = widget.distanceM - widget.distanceM % 10;
    }
    String distance = '${isKm ? distanceKm : distanceM} ${isKm ? 'km' : 'm'}';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showBottomSheetWith([
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.e['imageurl'],
                      fit: BoxFit.cover,
                      width: 340,
                      height: 190,
                    ),
                  ),
                ),
                Text(
                  widget.e['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 23),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.e['minidescription'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.e['description'],
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Address: ${widget.e['address']}, ${widget.e['district']}',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Distance: $distance',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
              onPressed: availOffer,
              icon: const Icon(Icons.add),
              label: const Text('Avail')),
        ], context);
        // Navigator.of(context).pushNamed(
        //   '/offerdetails',
        //   arguments: {'e': widget.e, 'distance': distance},
        // );
      },
      child: Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: CircleAvatar(
                    radius: 35.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.network(
                        widget.e['imageurl'],
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.e['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.e['minidescription'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Distance: $distance',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: availOffer,
                    icon: const Icon(Icons.add),
                    label: const Text('Avail')),
              ],
            )),
      ),
    );
  }

  void availOffer() {
    if (context.read<MainUser>().user!.verified == 'yes') {
      if (context.read<MainUser>().user!.coupons > 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Avail this offer?'),
                content: Text(
                    'Currently you have ${context.read<MainUser>().user!.coupons.toString()} coupons left. This will cost you 1 coupon.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No, go back.')),
                  TextButton(
                      onPressed: inProgress
                          ? null
                          : () {
                              setState(() {
                                inProgress = true;
                              });
                              if (context.read<MainUser>().user!.coupons > 0) {
                                HomeSetterPage.store
                                    .collection('users')
                                    .doc(context.read<MainUser>().user!.id)
                                    .update({
                                  'coupons':
                                      (context.read<MainUser>().user!.coupons -
                                          1),
                                });
                              }
                              HomeSetterPage.store
                                  .collection('codes')
                                  .add({
                                'id': context.read<MainUser>().user!.id,
                                'title': widget.e['title'],
                                'offerid': widget.e['code'],
                                'code':
                                    '${widget.e['code']}${context.read<MainUser>().user!.cNumber}${DateTime.now().toString()}',
                                'expiry': DateTime.now()
                                    .add(const Duration(days: 7))
                                    .toString(),
                              });
                              Navigator.of(context).pop();
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                showAvailed();
                              });
                              setState(() {
                                inProgress = false;
                              });
                            },
                      child: const Text('Yes.')),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Out of coupons!'),
                content: Text(
                    'You are all out of coupons. ${context.read<MainUser>().user!.premium ? '' : 'Subscribe to premium to get more coupons'}'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Get verified first'),
              content: const Text(
                  'You have to get verified first to be able to use this'),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok.')),
              ],
            );
          });
    }
  }

  void showAvailed() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Offer successfully availed'),
            content: Text(
                'Offer availed. You have ${context.read<MainUser>().user!.coupons.toString()} coupons left.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Yay!.'),
              ),
            ],
          );
        });
  }
}
