import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class DivisionIndicator extends StatelessWidget {
  const DivisionIndicator({Key? key, required this.divisionName})
      : super(key: key);

  final String divisionName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: MyPuttColors.skyBlue),
      child: Text(
        divisionName,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: MyPuttColors.darkGray, fontSize: 12),
      ),
    );
  }
}
