import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        AutoSizeText(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Bounceable(
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      darkMode ? MyPuttColors.gray[800] : MyPuttColors.gray[50],
                ),
                child: Icon(
                  FlutterRemix.close_line,
                  color:
                      darkMode ? MyPuttColors.white : MyPuttColors.gray[800]!,
                  size: 20,
                ),
              ),
              onTap: () {
                Vibrate.feedback(FeedbackType.light);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
