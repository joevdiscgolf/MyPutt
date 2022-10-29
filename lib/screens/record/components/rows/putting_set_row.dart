import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/screens/home/components/stats_view/rows/components/shadow_circular_indicator.dart';

class PuttingSetRow extends StatefulWidget {
  const PuttingSetRow({
    Key? key,
    required this.set,
    required this.index,
    required this.delete,
    required this.deletable,
  }) : super(key: key);
  final PuttingSet set;
  final int index;
  final Function delete;
  final bool deletable;

  @override
  State<PuttingSetRow> createState() => _PuttingSetRowState();
}

class _PuttingSetRowState extends State<PuttingSetRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 8;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: MyPuttColors.white,
          border: Border(
              bottom: BorderSide(color: MyPuttColors.gray[50]!, width: 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: width,
            child: Center(
              child: AutoSizeText('${widget.index + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: MyPuttColors.gray[600], fontSize: 20),
                  maxLines: 1),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          SizedBox(
            width: width,
            child: Center(
              child: AutoSizeText(
                  '${widget.set.puttsMade}/${widget.set.puttsAttempted}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: MyPuttColors.blue, fontSize: 20),
                  maxLines: 1),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          SizedBox(
              width: width,
              child: Center(
                child: AutoSizeText('${widget.set.distance} ft',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: MyPuttColors.gray[600], fontSize: 20),
                    maxLines: 1),
              )),
          const Spacer(),
          ShadowCircularIndicator(
            size: 60,
            decimal: widget.set.puttsMade / widget.set.puttsAttempted,
            // strokeWidth: 5,
          ),
          if (widget.deletable)
            SizedBox(
              width: 50,
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Icon(
                    FlutterRemix.close_line,
                    color: Colors.red,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                            actionPressed: widget.delete,
                            title: 'Delete set',
                            message:
                                'Are you sure you want to delete this set?',
                            buttonlabel: 'Delete',
                            buttonColor: MyPuttColors.red,
                            icon: const ShadowIcon(
                              icon: Icon(
                                FlutterRemix.alert_line,
                                color: MyPuttColors.red,
                                size: 60,
                              ),
                            )));
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
