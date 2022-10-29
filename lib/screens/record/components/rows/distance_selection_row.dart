import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class DistanceSelectionRow extends StatefulWidget {
  const DistanceSelectionRow({
    Key? key,
    required this.onIncreasePressed,
    required this.onDecreasePressed,
  }) : super(key: key);

  final Function(int) onIncreasePressed;
  final Function(int) onDecreasePressed;

  @override
  State<DistanceSelectionRow> createState() => _DistanceSelectionRowState();
}

class _DistanceSelectionRowState extends State<DistanceSelectionRow> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 20,
      ),
      decoration: BoxDecoration(
        color: MyPuttColors.gray[50],
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 2,
            color: MyPuttColors.gray[400]!,
          )
        ],
      ),
      child: Row(
        children: [
          const CircularIconContainer(
            icon: Icon(
              FlutterRemix.map_pin_2_line,
              color: MyPuttColors.blue,
              size: 32,
            ),
            size: 60,
            padding: 12,
          ),
          const SizedBox(width: 16),
          Text(
            'Distance',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray),
          ),
          const Spacer(),
          ElevatedButton(
            child: Text(
              '-',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
            ),
            onPressed: () {
              setState(() {
                if (_index == 0) {
                  _index = kDistanceOptions.length - 1;
                } else {
                  _index--;
                }
              });

              final int distance = kDistanceOptions[_index];

              widget.onDecreasePressed(distance);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 56,
            child: Column(
              children: [
                const SizedBox(height: 0),
                Text(
                  '${kDistanceOptions[_index]}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 20,
                        color: kDistanceOptions[_index] > CircleCutoffs.c2
                            ? MyPuttColors.darkBlue
                            : MyPuttColors.darkGray,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'ft',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 16,
                        color: MyPuttColors.darkGray,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            child: Text(
              '+',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 32, color: MyPuttColors.darkGray),
            ),
            onPressed: () {
              setState(() {
                if (_index == kDistanceOptions.length - 1) {
                  _index = 0;
                } else {
                  _index++;
                }
              });
              final int distance = kDistanceOptions[_index];

              widget.onDecreasePressed(distance);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
