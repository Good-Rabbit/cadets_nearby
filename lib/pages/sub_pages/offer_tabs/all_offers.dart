import 'package:cadets_nearby/pages/sub_pages/offer_tabs/ui_elements/offer_list.dart';
import 'package:flutter/material.dart';

class AllOffersTab extends StatefulWidget {
  const AllOffersTab({Key? key}) : super(key: key);

  @override
  State<AllOffersTab> createState() => _AllOffersTabState();
}

class _AllOffersTabState extends State<AllOffersTab> {
  RangeValues range = const RangeValues(0, 150);

  @override
  Widget build(BuildContext context) {
    return const OfferList();

  }
}