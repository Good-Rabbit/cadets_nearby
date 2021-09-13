import 'package:flutter/material.dart';

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
      child: Center(
        child: noOffer(context),
      ),
    );
  }

  Widget noOffer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.no_backpack,
          size: 70.0,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 10,),
        Text(
          "No offer",
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
