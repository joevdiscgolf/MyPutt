import 'package:flutter/material.dart';
import 'package:myputt/components/misc/custom_circular_progress_indicator.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/set_helpers.dart';

class PuttingSetRowV2 extends StatelessWidget {
  const PuttingSetRowV2({
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 32,
            child: Text(
              '${index + 1}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: MyPuttColors.gray[400]),
            ),
          ),
          const SizedBox(width: 16),
          CustomCircularProgressIndicator(
            percentage: percentageFromSet(set),
            color: MyPuttColors.skyBlue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(context),
                const SizedBox(height: 8),
                Text(
                  'From ${set.distance} ft',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: MyPuttColors.gray[400]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  RichText title(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: MyPuttColors.gray[800],
          fontWeight: FontWeight.w600,
        );
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${set.puttsMade}',
            style: style?.copyWith(color: MyPuttColors.blue),
          ),
          TextSpan(text: '/${set.puttsAttempted} putts made', style: style),
        ],
      ),
    );
  }
}
