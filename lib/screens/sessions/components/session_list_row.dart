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
      required this.stats,
      required this.isCurrentSession})
      : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;
  final Stats stats;
  final bool isCurrentSession;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.dateStarted, style: textStyle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
