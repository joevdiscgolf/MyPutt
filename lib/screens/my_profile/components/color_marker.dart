import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/utils/colors.dart';

class ColorMarker extends StatelessWidget {
  const ColorMarker(
      {Key? key,
      required this.size,
      required this.color,
      this.margin = const EdgeInsets.all(4),
      this.isSelected = false,
      this.onTap})
      : super(key: key);

  final double size;
  final Color color;
  final EdgeInsetsGeometry margin;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
          margin: margin,
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: MyPuttColors.gray, width: 2)
                : null,
          )),
    );
  }
}
