import 'package:flutter/material.dart';

class FilterRange extends StatefulWidget {
  const FilterRange({
    Key? key,
    required this.range,
    required this.max,
    required this.min,
    required this.onChanged,
  }) : super(key: key);
  final RangeValues range;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  @override
  _FilterRangeState createState() => _FilterRangeState();
}

class _FilterRangeState extends State<FilterRange> {
  bool once = true;
  RangeValues range = RangeValues(0, 5);
  @override
  Widget build(BuildContext context) {
    if (once) {
      once = false;
      range = widget.range;
    }
    return Column(
      children: [
        RangeSlider(
          values: range,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              range = value;
            });
          },
          min: widget.min,
          max: widget.max,
          divisions: 10,
          labels: RangeLabels('${range.start.ceil()}', '${range.end.ceil()}'),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ' + range.start.ceil().toString()),
              Text('Max: ' + range.end.ceil().toString()),
            ],
          ),
        ),
      ],
    );
  }
}
