
import 'package:flutter/material.dart';

class FilterSlider extends StatefulWidget {
  const FilterSlider({
    Key? key,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  }) : super(key: key);
  final int value;
  final String unit;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  FilterSliderState createState() => FilterSliderState();
}

class FilterSliderState extends State<FilterSlider> {
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
                'Upto: ${days.toInt()} ${widget.unit}',
              ),
              const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
