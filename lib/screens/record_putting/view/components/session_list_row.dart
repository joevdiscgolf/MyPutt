import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/record_putting/view/components/dialogs/confirm_delete_dialog.dart';
import 'package:myputt/data/types/putting_session.dart';

class SessionListRow extends StatelessWidget {
  const SessionListRow(
      {Key? key, required this.session, this.index, required this.delete})
      : super(key: key);
  final Function delete;
  final PuttingSession session;
  final int? index;

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
            Text('${index ?? '0'}: ${session.dateStarted}', style: textStyle),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  child: const Icon(FlutterRemix.delete_bin_fill),
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
