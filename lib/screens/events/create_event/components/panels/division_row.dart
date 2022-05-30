import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/utils/colors.dart';

class DivisionRow extends StatelessWidget {
  const DivisionRow({
    Key? key,
    required this.division,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final Division division;
  final bool selected;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
            color: selected ? MyPuttColors.blue : Colors.transparent,
            border: Border.all(
              color: selected ? Colors.transparent : MyPuttColors.blue,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          division.name.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: selected ? MyPuttColors.white : MyPuttColors.darkBlue,
              fontSize: 14),
        ),
      ),
    );
  }
}
