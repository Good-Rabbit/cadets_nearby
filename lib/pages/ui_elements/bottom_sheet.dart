import 'package:flutter/material.dart';

showBottomSheetWith(List<Widget> child, BuildContext context) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: ListView(
                  controller: controller,
                  children: child,
                ),
              ),
            ),
          ),
        );
      });
}
