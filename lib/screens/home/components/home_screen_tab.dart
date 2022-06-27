import 'package:flutter/material.dart';

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({
    Key? key,
    required this.label,
    this.icon,
  }) : super(key: key);

  final String label;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Tab(
          icon: icon,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
