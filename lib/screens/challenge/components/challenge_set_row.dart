import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ChallengeSetRow extends StatelessWidget {
  const ChallengeSetRow(
      {Key? key,
      required this.currentUserMade,
      required this.opponentMade,
      required this.setLength,
      this.distance})
      : super(key: key);

  final int currentUserMade;
  final int opponentMade;
  final int setLength;
  final int? distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (distance != null)
            Text('$distance ft',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: AutoSizeText(
                  '$currentUserMade/$setLength',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
                  maxLines: 1,
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: LinearPercentIndicator(
                  percent: opponentMade + currentUserMade == 0
                      ? 0
                      : currentUserMade.toDouble() /
                          (opponentMade + currentUserMade).toDouble(),
                  progressColor: MyPuttColors.blue,
                  backgroundColor: MyPuttColors.red,
                  barRadius: const Radius.circular(4),
                  lineHeight: 8,
                  // fillColor: MyPuttColors.blue,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: AutoSizeText(
                  '$opponentMade/$setLength',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
                  maxLines: 1,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
