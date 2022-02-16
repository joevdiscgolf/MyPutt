import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/confirm_dialog.dart';
import 'package:myputt/components/search_users_sheet.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/theme/theme_data.dart';

import '../../../cubits/challenges_cubit.dart';

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
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey[400]!),
        color: isCurrentSession ? Colors.blue[100]! : Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          isCurrentSession
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text('CURRENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ))))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.dateStarted, style: textStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${session.sets.length.toString()} sets'),
                        const SizedBox(width: 20),
                        stats.generalStats?.totalMade != null &&
                                stats.generalStats?.totalAttempts != null
                            ? Text(
                                '${stats.generalStats?.totalMade} / ${stats.generalStats?.totalAttempts} putts')
                            : Container()
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
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => SearchUsersSheet(
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
