import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/screens/record/components/record_tab/tiles/adjust_distance_button.dart';
import 'package:myputt/screens/record/components/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';

class DistanceSelectionTile extends StatelessWidget {
  const DistanceSelectionTile({Key? key, this.initialDistance = 10})
      : super(key: key);

  final int initialDistance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Distance',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w600,
                color: MyPuttColors.gray[400],
              ),
        ),
        const SizedBox(height: 8),
        SelectionTile(
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: AdjustDistanceButton(increment: false)),
                VerticalDivider(
                  width: 1,
                  color: MyPuttColors.gray[200]!,
                  thickness: 1,
                ),
                Expanded(
                  child: AutoSizeText(
                    '10',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MyPuttColors.darkGray,
                        ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  color: MyPuttColors.gray[200]!,
                  thickness: 1,
                ),
                const Expanded(child: AdjustDistanceButton(increment: true)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
