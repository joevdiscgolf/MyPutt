import 'package:flutter/material.dart';

class PercentageRow extends StatefulWidget {
  const PercentageRow(
      {Key? key, required this.distance, required this.percentage})
      : super(key: key);

  final double percentage;
  final int distance;

  @override
  State<PercentageRow> createState() => _PercentageRowState();
}

class _PercentageRowState extends State<PercentageRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(widget.distance.toString() + ' ft',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(width: 20),
        SizedBox(
          child: Stack(children: <Widget>[
            SizedBox(
                width: 80,
                height: 80,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: widget.percentage),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, _) => CircularProgressIndicator(
                    color: widget.percentage < 0.5 ? Colors.red : Colors.green,
                    backgroundColor: Colors.grey[200],
                    value: value,
                    strokeWidth: 5,
                  ),
                )),
            Center(
                child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: widget.percentage),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, _) =>
                        (Text((value * 100).round().toString() + ' %'))))
          ]),
          width: 80,
          height: 80,
        )
      ]),
    );
  }
}
