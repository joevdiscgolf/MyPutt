import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/primary_button.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('${index ?? '0'}: ${session.dateStarted}', style: textStyle),
            ElevatedButton(
                child: const Icon(FlutterRemix.delete_bin_fill),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          ConfirmDeleteDialog(delete: delete));
                })
          ],
        ),
      ),
    );
  }
}

class ConfirmDeleteDialog extends StatefulWidget {
  const ConfirmDeleteDialog({Key? key, required this.delete}) : super(key: key);

  final Function delete;
  @override
  _ConfirmDeleteDialogState createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  String? _dialogErrorText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Finish Putting Session',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(_dialogErrorText ?? ''),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                        width: 100,
                        height: 50,
                        label: 'Cancel',
                        fontSize: 18,
                        labelColor: Colors.grey[600]!,
                        backgroundColor: Colors.grey[200]!,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    PrimaryButton(
                      label: 'Delete',
                      fontSize: 18,
                      width: 100,
                      height: 50,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        widget.delete();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
