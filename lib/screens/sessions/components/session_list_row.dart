import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/components/confirm_delete_dialog.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/locator.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow(
      {Key? key,
      required this.session,
      this.index,
      required this.delete,
      required this.stats})
      : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;
  final Stats stats;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(session.dateStarted, style: textStyle),
                  Text('${session.sets.length.toString()} sets'),
                  stats.generalStats?.totalMade != null &&
                          stats.generalStats?.totalAttempts != null
                      ? Text(
                          '${stats.generalStats?.totalMade} / ${stats.generalStats?.totalAttempts}')
                      : Container(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
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
                        builder: (context) => ConfirmDeleteDialog(
                            title: 'Delete Session', delete: delete));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
