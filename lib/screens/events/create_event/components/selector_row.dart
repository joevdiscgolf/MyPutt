import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class SelectorRow extends StatelessWidget {
  const SelectorRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.showArrow = true,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final Function onPressed;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback((FeedbackType.light));
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: MyPuttColors.gray[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: AutoSizeText(
                text,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: MyPuttColors.darkGray, fontSize: 14),
              ),
            ),
            if (showArrow)
              const Icon(
                FlutterRemix.arrow_down_s_line,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
