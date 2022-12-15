import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class EventCategoryTab extends StatelessWidget {
  const EventCategoryTab({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tab(
        icon: icon,
        child: FittedBox(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: MyPuttColors.darkGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
