import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/screens/components/confirm_delete_dialog.dart';

class PuttingSetRow extends StatefulWidget {
  const PuttingSetRow(
      {Key? key,
      required this.set,
      required this.index,
      required this.delete,
      required this.deletable})
      : super(key: key);
  final PuttingSet set;
  final int index;
  final Function delete;
  final bool deletable;

  @override
  State<PuttingSetRow> createState() => _PuttingSetRowState();
}

class _PuttingSetRowState extends State<PuttingSetRow> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 50,
              child: Text('${widget.index + 1}', style: textStyle),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text('${widget.set.puttsMade}/${widget.set.puttsAttempted}',
                style: textStyle),
          ),
          SizedBox(
            width: 50,
            child: Text(
                '${(100 * widget.set.puttsMade / widget.set.puttsAttempted).round()} %',
                style: textStyle),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
              backgroundColor: Colors.grey[200],
              value: widget.set.puttsMade / widget.set.puttsAttempted,
              strokeWidth: 5,
            ),
          ),
          SizedBox(
              width: 50,
              child: Center(
                  child: Text('${widget.set.distance} ft', style: textStyle))),
          widget.deletable
              ? SizedBox(
                  width: 50,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: const Icon(
                        FlutterRemix.close_line,
                        color: Colors.red,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => ConfirmDeleteDialog(
                                delete: widget.delete, title: 'Delete set'));
                      },
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
