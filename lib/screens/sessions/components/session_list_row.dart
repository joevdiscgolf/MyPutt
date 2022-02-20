import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:myputt/components/confirm_dialog.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';

import '../../share/share_sheet.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow({
    Key? key,
    required this.session,
    this.index,
    required this.delete,
    required this.stats,
    required this.isCurrentSession,
  }) : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;
  final Stats stats;
  final bool isCurrentSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colors.grey[400]!),
        color: isCurrentSession ? Colors.blue[100]! : Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Visibility(
            visible: isCurrentSession,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'CURRENT',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ))),
          ),
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
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
              Visibility(
                visible: !isCurrentSession,
                child: Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Icon(
                      FlutterRemix.sword_line,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => ShareSheet(
                                session: session,
                              ));
                    },
                  ),
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
    );
  }
}
