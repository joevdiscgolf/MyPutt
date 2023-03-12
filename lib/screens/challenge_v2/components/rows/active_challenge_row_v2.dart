import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/record/record_screen.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ActiveChallengeRowV2 extends StatelessWidget {
  const ActiveChallengeRowV2({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  static const double _rowHeight = 124;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: MyPuttColors.white,
      child: Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const RecordScreen();
              },
            ),
          );
        },
        child: SizedBox(
          height: _rowHeight,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: standardBoxShadow(),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: const AssetImage(
                      'assets/images/winthrop_hole_6_putt.JPG',
                    ),
                    colorFilter: ColorFilter.mode(
                      MyPuttColors.gray[700]!.withOpacity(0.9),
                      BlendMode.srcOver,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 24),
                  height: _rowHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 24),
                          alignment: Alignment.topRight,
                          child: _challengeScoreRichText(context),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${challenge.opponentUser?.displayName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: MyPuttColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat.yMMMd('en_us').format(
                                        (DateTime.fromMillisecondsSinceEpoch(
                                            challenge.creationTimeStamp))),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: MyPuttColors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16, right: 16),
                            child: Icon(
                              FlutterRemix.arrow_right_s_line,
                              color: MyPuttColors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(24, -12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FrisbeeCircleIcon(
                    frisbeeAvatar: challenge.opponentUser?.frisbeeAvatar,
                    size: 52,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  RichText _challengeScoreRichText(BuildContext context) {
    final TextStyle? textStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: MyPuttColors.white,
            );
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${totalMadeFromSets(challenge.currentUserSets)}',
            style: textStyle?.copyWith(color: MyPuttColors.blue),
          ),
          TextSpan(
            text: ' - ${totalMadeFromSets(challenge.opponentSets)}',
            style: textStyle,
          )
        ],
      ),
    );
  }
}
