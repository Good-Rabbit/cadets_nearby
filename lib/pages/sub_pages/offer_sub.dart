import 'package:cadets_nearby/pages/sub_pages/offer_tabs/availed_offers.dart';
import 'package:flutter/material.dart';

import 'offer_tabs/all_offers.dart';
import 'offer_tabs/nearby_offers.dart';

class OfferSubPage extends StatefulWidget {
  const OfferSubPage({Key? key}) : super(key: key);

  @override
  _OfferSubPageState createState() => _OfferSubPageState();
}

class _OfferSubPageState extends State<OfferSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Column(
                    children: [
                      Icon(
                        Icons.all_inclusive_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text('All Offers',style: TextStyle(color: Theme.of(context).primaryColor),),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    children: [
                      Icon(
                        Icons.near_me_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text('Nearby Offers',style: TextStyle(color: Theme.of(context).primaryColor),),
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
                      Text('Availed Offers',style: TextStyle(color: Theme.of(context).primaryColor),),
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  AllOffersTab(),
                  NearbyOffersTab(),
                  AvailedOffersTab(),
                ],
              ),
            )
          ],
        ),
      ),
      // allOffers(context),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
