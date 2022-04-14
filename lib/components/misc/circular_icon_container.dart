import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CircularIconContainer extends StatelessWidget {
  const CircularIconContainer(
      {Key? key, required this.icon, this.padding = 12, this.size = 40})
      : super(key: key);

  final Widget icon;
  final double padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 4),
            color: MyPuttColors.gray[300]!,
            blurRadius: 6),
      ], shape: BoxShape.circle, color: MyPuttColors.gray[50]),
      child: Center(child: icon),
    );
  }
}
