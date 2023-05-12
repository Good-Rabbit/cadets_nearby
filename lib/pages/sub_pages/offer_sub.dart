import 'package:cadets_nearby/pages/sub_pages/offer_tabs/global_offer_list.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_tabs/offer_list.dart';
import 'package:cadets_nearby/pages/sub_pages/offer_tabs/ui_elements/offers_top_row.dart';
import 'package:flutter/material.dart';

class OfferSubPage extends StatefulWidget {
  const OfferSubPage({Key? key}) : super(key: key);

  @override
  OfferSubPageState createState() => OfferSubPageState();
}

class OfferSubPageState extends State<OfferSubPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                tabs: [
                  Tab(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.backpack_rounded,
                        ),
                        Text(
                          'All Offers',
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.all_inclusive_rounded,
                        ),
                        Text(
                          'Nearby Offers',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            OffersTopRow(context: context),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GlobalOfferList(),
                  OfferList(),
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
