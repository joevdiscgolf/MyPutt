import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/screens/sessions/components/percentage_column.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/helpers.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow(
      {Key? key,
      required this.session,
      this.index,
      required this.delete,
      required this.stats,
      required this.isCurrentSession,
      required this.onTap})
      : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;
  final Stats stats;
  final bool isCurrentSession;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey[400]!),
          color: isCurrentSession ? Colors.blue[100]! : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.dateStarted,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${session.sets.length.toString()} sets',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 20),
                          Visibility(
                            visible: stats.generalStats?.totalMade != null &&
                                stats.generalStats?.totalAttempts != null,
                            child: Text(
                              '${stats.generalStats?.totalMade} / ${stats.generalStats?.totalAttempts} putts',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IntrinsicHeight(
                          child: Row(
                            // alignment: WrapAlignment.spaceBetween,
                            children: getPercentageColumnChildren(stats),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Icon(
                      FlutterRemix.sword_fill,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      Vibrate.feedback(FeedbackType.light);
                      showBarModalBottomSheet(
                          topControl: Container(),
                          bounce: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          context: context,
                          builder: (context) => ShareSheet(
                                onComplete: () => Navigator.pop(context),
                                session: session,
                              ));
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Icon(
                        FlutterRemix.close_line,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Vibrate.feedback(FeedbackType.light);
                        showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                                  title: 'Delete Session',
                                  actionPressed: delete,
                                  confirmColor: Colors.red,
                                  buttonlabel: 'Delete',
                                ));
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
