import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/string_helpers.dart';

class ActiveSessionRow extends StatelessWidget {
  const ActiveSessionRow(
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.grey[400]!),
            color: isCurrentSession
                ? MyPuttColors.lightBlue.withOpacity(0.2)
                : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(timestampToDate(session.timeStamp),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'CURRENT',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.blue, fontSize: 16),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...getPercentageColumnChildren(stats),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(
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
                                    buttonlabel: 'Delete',
                                    buttonColor: Colors.red,
                                    icon: const Icon(
                                        FlutterRemix.error_warning_fill),
                                  ));
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              )
            ],
          ),
        ));
  }
}
