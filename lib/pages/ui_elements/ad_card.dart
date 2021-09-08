
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdCard extends StatefulWidget {
  const AdCard({
    Key? key,
    required this.ad,
  }) : super(key: key);

  final BannerAd ad;

  @override
  _AdCardState createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: widget.ad.size.width.toDouble(),
          height: widget.ad.size.height.toDouble(),
          child: ClipRRect(borderRadius: BorderRadius.circular(20.0),child: AdWidget(ad: widget.ad)),
        ),
      ),
    );
  }
}
