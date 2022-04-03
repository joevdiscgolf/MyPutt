import 'package:flutter/material.dart';

class EventCategoryTab extends StatelessWidget {
  const EventCategoryTab({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tab(
          icon: icon,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label),
            ],
          )),
    );
  }
}
