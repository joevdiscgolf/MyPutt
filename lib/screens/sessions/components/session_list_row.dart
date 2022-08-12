import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/screens/share/share_sheet.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/string_helpers.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow({
    Key? key,
    required this.session,
    this.index,
    required this.delete,
    required this.isCurrentSession,
    required this.onTap,
  }) : super(key: key);
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
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: MyPuttColors.gray[300]!,
              blurRadius: 1,
            )
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
                const SizedBox(height: 8)
              ],
              Text(
                timestampToDate(session.timeStamp),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: MyPuttColors.gray[600], fontSize: 12),
              ),
              const SizedBox(height: 8),
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
                locator
                    .get<Mixpanel>()
                    .track('Session Row Challenge Button Pressed');
                Vibrate.feedback(FeedbackType.light);
                showBarModalBottomSheet(
                  topControl: Container(),
                  context: context,
                  builder: (BuildContext context) => ShareSheet(
                    session: session,
                    onComplete: () => Navigator.pop(context),
                  ),
                );
              },
              child: const Icon(
                FlutterRemix.sword_fill,
                color: MyPuttColors.blue,
                size: 24,
              ),
            ),
          const SizedBox(
            width: 12,
          ),
          Bounceable(
            onTap: () {
              Vibrate.feedback(FeedbackType.light);
              locator
                  .get<Mixpanel>()
                  .track('Session List Row Delete Button Pressed');
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(
                  actionPressed: delete,
                  title: 'Delete session',
                  message: 'Are you sure you want to delete this session?',
                  buttonlabel: 'Delete',
                  buttonColor: MyPuttColors.red,
                  icon: const ShadowIcon(
                    icon: Icon(
                      FlutterRemix.alert_line,
                      color: MyPuttColors.red,
                      size: 60,
                    ),
                  ),
                ),
              );
            },
            child: const Icon(
              FlutterRemix.delete_bin_7_line,
              color: MyPuttColors.red,
              size: 20,
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
