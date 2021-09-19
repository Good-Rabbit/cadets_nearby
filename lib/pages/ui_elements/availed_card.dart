import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvailedCard extends StatefulWidget {
  const AvailedCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> e;

  @override
  State<AvailedCard> createState() => _AvailedCardState();
}

class _AvailedCardState extends State<AvailedCard> {
  @override
  Widget build(BuildContext context) {
    DateTime expiry = DateTime.parse(widget.e.data()['expiry']);
    if (expiry.isBefore(DateTime.now())) {
      delCode();
    }
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.e.data()['title'],
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    widget.e.data()['offerid'],
                  ),
                  Text(
                    'Expiry: ${expiry.toString().split('.').first}',
                  ),
                ],
              ),
            ),
            if (expiry.isAfter(DateTime.now()))
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/availedofferdetails', arguments: widget.e);
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Scan')),
            if (!expiry.isAfter(DateTime.now()))
              const Chip(
                label: Text(
                  'Expired',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
                avatar: Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> delCode() async {
    widget.e.reference.delete();
  }
}
