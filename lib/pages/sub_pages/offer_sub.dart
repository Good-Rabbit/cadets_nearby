import 'package:cadets_nearby/pages/sub_pages/offer_tabs/global_offer_list.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_tabs/offer_list.dart';
import 'package:flutter/material.dart';

class OfferSubPage extends StatefulWidget {
  const OfferSubPage({Key? key}) : super(key: key);

  @override
  _OfferSubPageState createState() => _OfferSubPageState();
}

class _OfferSubPageState extends State<OfferSubPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
              tabs: [
                Tab(
                  child: Column(
                    children: [
                      Icon(
                        Icons.all_inclusive_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Regional Offers',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    children: [
                      Icon(
                        Icons.backpack_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'All Offers',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  OfferList(),
                  GlobalOfferList(),
                ],
              ),
            )
          ],
        ),
      ),
      // allOffers(context),
    );
  }
}
