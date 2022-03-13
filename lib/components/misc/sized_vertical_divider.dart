import 'package:flutter/material.dart';

class SizedVerticalDivider extends StatelessWidget {
  const SizedVerticalDivider({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 30,
        child: VerticalDivider(
          color: color,
          thickness: 1,
          width: 24,
        ),
      ),
    );
  }
}
