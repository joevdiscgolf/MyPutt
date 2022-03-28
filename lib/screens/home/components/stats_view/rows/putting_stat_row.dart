import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

import 'components/shadow_circular_indicator.dart';

class PuttingStatRow extends StatelessWidget {
  const PuttingStatRow({
    Key? key,
    this.backgroundColor = MyPuttColors.white,
    required this.distance,
    required this.percentage,
    required this.allTimePercentage,
  }) : super(key: key);

  final Color backgroundColor;
  final num? percentage;
  final num? allTimePercentage;
  final int distance;

  @override
  Widget build(BuildContext context) {
    final double indicatorSize = MediaQuery.of(context).size.height * 0.1;
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Bounceable(
          onTap: () {
            Vibrate.feedback(FeedbackType.light);
          },
          child: ShadowCircularIndicator(
              size: indicatorSize, decimal: percentage?.toDouble()),
        ),
        const SizedBox(
          width: 40,
        ),
        Column(
          children: [
            SizedBox(
              width: 80,
              child: Text(distance.toString() + ' ft',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: MyPuttColors.darkGray, fontSize: 24)),
            ),
            Builder(builder: (context) {
              if (allTimePercentage != null && percentage != null) {
                return SizedBox(
                  width: 60,
                  child: Row(children: <Widget>[
                    percentage! < allTimePercentage!
                        ? const Icon(FlutterRemix.arrow_down_line,
                            color: MyPuttColors.red)
                        : const Icon(FlutterRemix.arrow_up_line,
                            color: MyPuttColors.lightBlue),
                    Text(
                        (100 * (percentage! - allTimePercentage!))
                                .round()
                                .toString() +
                            ' %',
                        style: TextStyle(
                          color: percentage! < allTimePercentage!
                              ? MyPuttColors.red
                              : MyPuttColors.lightBlue,
                        ))
                  ]),
                );
              } else {
                return const SizedBox(width: 60, child: Text('- %'));
              }
            }),
          ],
        ),
      ]),
    );
  }
}
