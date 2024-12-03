import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class GenericChartOverlayText extends StatelessWidget {
  const GenericChartOverlayText({
    super.key,
    required this.message,
    required this.height,
    this.isDarkBackground = false,
  });

  final String message;
  final double height;
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color:
                  isDarkBackground ? MyPuttColors.white : MyPuttColors.darkGray,
            ),
      ),
    );
  }
}
