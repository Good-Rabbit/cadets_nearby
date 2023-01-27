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
                  color: Theme.of(context).bottomAppBarTheme.color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
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
