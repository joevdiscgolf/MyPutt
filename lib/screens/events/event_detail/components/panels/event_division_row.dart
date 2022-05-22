import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/utils/colors.dart';

class EventDivisionRow extends StatelessWidget {
  const EventDivisionRow(
      {Key? key, required this.division, required this.onDivisionTap})
      : super(key: key);

  final Division division;
  final Function onDivisionTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => onDivisionTap(division),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Text(
            division.name.toUpperCase(),
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color: MyPuttColors.darkGray,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
