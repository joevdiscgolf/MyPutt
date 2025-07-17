import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myputt/utils/colors.dart';

class MainWrapperBottomNavItem extends StatelessWidget {
  const MainWrapperBottomNavItem({
    Key? key,
    required this.iconData,
    this.iconSize = 24,
    this.height = 72,
    required this.isSelected,
    required this.bottomPadding,
    required this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final double iconSize;
  final double height;
  final bool isSelected;
  final double bottomPadding;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: bottomPadding, top: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: isSelected
                ? const Border(
                    top: BorderSide(color: MyPuttColors.blue, width: 2),
                  )
                : const Border(
                    top: BorderSide(color: Colors.transparent, width: 2))),
        child: SizedBox(
          height: iconSize,
          width: iconSize,
          child: Icon(
            iconData,
            size: iconSize,
            color: isSelected ? MyPuttColors.blue : MyPuttColors.gray[800]!,
          ),
        ),
      ),
    );
  }
}
