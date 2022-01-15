import 'package:flutter/material.dart';

class PercentageRow extends StatelessWidget {
  const PercentageRow(
      {Key? key, required this.distance, required this.percentage})
      : super(key: key);

  final double percentage;
  final int distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Text(distance.toString()),
        const SizedBox(width: 20),
        CircularProgressIndicator(
          color: Colors.green,
          value: percentage,
          strokeWidth: 5,
        )
      ]),
    );
  }
}
