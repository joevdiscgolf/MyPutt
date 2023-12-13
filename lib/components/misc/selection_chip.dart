import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class SelectionChip extends StatelessWidget {
  const SelectionChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.isDarkBackground = false,
  }) : super(key: key);

  final String label;
  final bool isSelected;
  final Function onPressed;
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Color? _getTextColor() {
    if (isDarkBackground) {
      return isSelected ? MyPuttColors.darkGray : MyPuttColors.offWhite;
    } else {
      return isSelected ? MyPuttColors.offWhite : MyPuttColors.darkGray;
    }
  }

  Color? _getBackgroundColor() {
    if (isDarkBackground) {
      return isSelected ? MyPuttColors.white : MyPuttColors.gray[800];
    } else {
      return isSelected ? MyPuttColors.gray[700] : MyPuttColors.white;
    }
  }
}
