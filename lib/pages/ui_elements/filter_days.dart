
import 'package:flutter/material.dart';

class FilterDays extends StatefulWidget {
  const FilterDays({
    Key? key,
    required this.value,
    required this.max,
    required this.min,
    required this.onChanged,
    this.divisions = 30,
  }) : super(key: key);
  final int value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  _FilterDaysState createState() => _FilterDaysState();
}

class _FilterDaysState extends State<FilterDays> {
  bool once = true;
  double days = 30;

  @override
  Widget build(BuildContext context) {
    if (once) {
      once = false;
      days = widget.value.toDouble();
    }
    return Column(
      children: [
        Slider(
          value: days,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              days = value;
            });
          },
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: '${days.toInt()}',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upto: ${days.toInt()} days ago',
              ),
              const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
