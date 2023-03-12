import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ScrubberLabel extends StatelessWidget {
  const ScrubberLabel({
    Key? key,
    required this.dateLabel,
    required this.percentage,
    required this.horizontalOffset,
  }) : super(key: key);

  final String dateLabel;
  final double percentage;
  final double horizontalOffset;

  @override
  Widget build(BuildContext context) {
    final double textWidth = getTextWidth(
      dateLabel,
      Theme.of(context).textTheme.bodyLarge!,
    );
    return Transform.translate(
      offset: Offset(-textWidth / 2 + horizontalOffset, -32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            dateLabel,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            '${(percentage * 100).toInt()}%',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: MyPuttColors.blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
