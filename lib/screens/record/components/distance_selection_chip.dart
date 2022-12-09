import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/distance_helpers.dart';

class DistanceSelectionChip extends StatelessWidget {
  const DistanceSelectionChip({
    Key? key,
    required this.distance,
    required this.onDistanceSelected,
  }) : super(key: key);

  final int distance;
  final Function(int) onDistanceSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: MyPuttColors.gray[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Bounceable(
            onTap: () {
              _onDistanceStepped(true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyPuttColors.gray[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container()),
                Text(
                  '$distance',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      ' ft',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Bounceable(
            onTap: () {
              _onDistanceStepped(false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyPuttColors.gray[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  '-',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDistanceStepped(bool incremented) {
    Vibrate.feedback(FeedbackType.medium);
    late int index;
    if (kDistanceOptions.contains(distance)) {
      index = kDistanceOptions.indexOf(distance);
      if (incremented) {
        if (index == kDistanceOptions.length - 1) {
          index = 0;
        } else {
          index++;
        }
      } else {
        if (index == 0) {
          index = kDistanceOptions.length - 1;
        } else {
          index--;
        }
      }
    } else {
      index = findNextIndexInDistanceList(distance, incremented);
    }

    onDistanceSelected(kDistanceOptions[index]);
  }
}
