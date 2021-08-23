import 'package:flutter/material.dart';

class FilterRange extends StatefulWidget {
  const FilterRange({
    Key? key,
    required this.range,
    required this.max,
    required this.min,
    required this.onChanged,
    this.divisions: 5,
  }) : super(key: key);
  final RangeValues range;
  final double min;
  final double max;
  final int divisions;
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
          divisions: widget.divisions,
          labels: RangeLabels('${range.start.floor()}', '${range.end.ceil()}'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: ' + range.start.ceil().toString(),
                style: TextStyle(),
              ),
              Text(
                'Max: ' + range.end.ceil().toString(),
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
