import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow(
      {Key? key,
      required this.session,
      this.index,
      required this.delete,
      required this.isCurrentSession,
      required this.onTap})
      : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;
  final bool isCurrentSession;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final int setCount = session.sets.length;
    final int puttsAttempted = totalAttemptsFromSets(session.sets);

    return Bounceable(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                color: MyPuttColors.gray[300]!,
                blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(16),
          color: MyPuttColors.gray[50],
        ),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCurrentSession) ...[
                Text(
                  'In progress',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: MyPuttColors.red, fontSize: 12),
                ),
                const SizedBox(
                  height: 8,
                )
              ],
              Text(
                session.dateStarted,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: MyPuttColors.gray[600], fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$setCount sets, $puttsAttempted putts',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: MyPuttColors.blue, fontSize: 16),
              )
            ],
          ),
          const Spacer(),
          if (!isCurrentSession)
            Bounceable(
              onTap: () {
                Vibrate.feedback(FeedbackType.light);
                showBarModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => ShareSheet(
                          session: session,
                          onComplete: () => Navigator.pop(context),
                        ));
              },
              child: const Icon(
                FlutterRemix.sword_fill,
                color: MyPuttColors.blue,
                size: 32,
              ),
            ),
          const SizedBox(
            width: 8,
          ),
          Icon(
            FlutterRemix.arrow_right_s_line,
            color: MyPuttColors.gray[300]!,
            size: 24,
          ),
        ]),
      ),
    );
  }
}
