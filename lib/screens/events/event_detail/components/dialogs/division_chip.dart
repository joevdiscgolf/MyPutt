import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/utils/colors.dart';

class DivisionChip extends StatelessWidget {
  const DivisionChip(
      {Key? key,
      required this.division,
      required this.onPressed,
      required this.selected})
      : super(key: key);

  final Division division;
  final Function(Division division) onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => onPressed(division),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: MyPuttColors.blue),
            borderRadius: BorderRadius.circular(8),
            color: selected ? MyPuttColors.blue : Colors.transparent),
        child: Text(
          division.name.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: selected ? MyPuttColors.white : MyPuttColors.darkBlue,
              fontSize: 16),
        ),
      ),
    );
  }
}
