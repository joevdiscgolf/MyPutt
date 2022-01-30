import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class PercentageRow extends StatefulWidget {
  const PercentageRow(
      {Key? key,
      required this.distance,
      required this.percentage,
      required this.allTimePercentage})
      : super(key: key);

  final num? percentage;
  final num? allTimePercentage;
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
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 90,
            child: Text(widget.distance.toString() + ' ft',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
        const SizedBox(width: 20),
        Builder(builder: (context) {
          if (widget.allTimePercentage != null && widget.percentage != null) {
            return SizedBox(
              child: Stack(children: <Widget>[
                SizedBox(
                    width: 90,
                    height: 90,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                          begin: 0.0, end: widget.percentage! as double),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, _) => CircularProgressIndicator(
                        color: widget.percentage! < widget.allTimePercentage!
                            ? Colors.red
                            : Colors.greenAccent,
                        backgroundColor: Colors.grey[200],
                        value: value,
                        strokeWidth: 5,
                      ),
                    )),
                Center(
                    child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                            begin: 0.0, end: widget.percentage as double),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, _) =>
                            (Text((value * 100).round().toString() + ' %'))))
              ]),
              width: 90,
              height: 90,
            );
          } else {
            return SizedBox(
              child: Stack(children: <Widget>[
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    color: Colors.grey[400],
                    backgroundColor: Colors.grey[200],
                    value: 0,
                    strokeWidth: 5,
                  ),
                ),
                const Center(child: Text('- %')),
              ]),
              width: 90,
              height: 90,
            );
          }
        }),
        const SizedBox(
          width: 30,
        ),
        Builder(builder: (context) {
          if (widget.allTimePercentage != null && widget.percentage != null) {
            return SizedBox(
              width: 90,
              child: Row(children: <Widget>[
                widget.percentage! < widget.allTimePercentage!
                    ? const Icon(FlutterRemix.arrow_down_line,
                        color: Colors.red)
                    : const Icon(FlutterRemix.arrow_up_line,
                        color: Colors.greenAccent),
                Text(
                    (100 * (widget.percentage! - widget.allTimePercentage!))
                            .round()
                            .toString() +
                        ' %',
                    style: TextStyle(
                      color: widget.percentage! < widget.allTimePercentage!
                          ? Colors.red
                          : Colors.greenAccent,
                    ))
              ]),
            );
          } else {
            return const SizedBox(width: 90, child: Text('- %'));
          }
        }),
      ]),
    );
  }
}
