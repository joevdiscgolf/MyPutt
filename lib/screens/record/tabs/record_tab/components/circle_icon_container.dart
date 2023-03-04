import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CircleIconContainer extends StatelessWidget {
  const CircleIconContainer({
    Key? key,
    required this.icon,
    this.size = 52,
    this.iconSize = 20,
  }) : super(key: key);

  final Widget icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration:
          BoxDecoration(color: MyPuttColors.gray[100], shape: BoxShape.circle),
      child: Center(child: icon),
    );
  }
}
