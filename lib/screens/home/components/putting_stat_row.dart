import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/screens/home/components/line_chart_preview.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';

class PuttingStatRow extends StatefulWidget {
  const PuttingStatRow(
      {Key? key,
      required this.distance,
      required this.percentage,
      required this.allTimePercentage,
      this.chartPoints = const []})
      : super(key: key);

  final num? percentage;
  final num? allTimePercentage;
  final int distance;
  final List<ChartPoint> chartPoints;

  @override
  State<PuttingStatRow> createState() => _PuttingStatRowState();
}

class _PuttingStatRowState extends State<PuttingStatRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 80,
            child: Text(widget.distance.toString() + ' ft',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
        const SizedBox(width: 10),
        Bounceable(
          onTap: () {
            Vibrate.feedback(FeedbackType.light);
          },
          child: Builder(builder: (context) {
            if (widget.allTimePercentage != null && widget.percentage != null) {
              return SizedBox(
                child: Stack(children: <Widget>[
                  SizedBox(
                      width: 90,
                      height: 90,
                      child: TweenAnimationBuilder<double>(
                        curve: Curves.easeOutQuad,
                        tween: Tween<double>(
                            begin: 0.0, end: widget.percentage! as double),
                        duration: const Duration(milliseconds: 750),
                        builder: (context, value, _) =>
                            CircularProgressIndicator(
                          color: widget.percentage! < widget.allTimePercentage!
                              ? Colors.red
                              : MyPuttColors.lightGreen,
                          backgroundColor: Colors.grey[200],
                          value: value,
                          strokeWidth: 5,
                        ),
                      )),
                  Center(
                      child: TweenAnimationBuilder<double>(
                          curve: Curves.easeInOutQuad,
                          tween: Tween<double>(
                              begin: 0.0, end: widget.percentage as double),
                          duration: const Duration(milliseconds: 750),
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
        ),
        const SizedBox(
          width: 16,
        ),
        Builder(builder: (context) {
          if (widget.allTimePercentage != null && widget.percentage != null) {
            return SizedBox(
              width: 60,
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
            return const SizedBox(width: 60, child: Text('- %'));
          }
        }),
        FittedBox(
          child: LineChartPreview(
              data: smoothChart(
                  PerformanceChartData(points: widget.chartPoints), 2)),
        )
      ]),
    );
  }
}
