import 'package:flutter/material.dart';

class GenericChartOverlayText extends StatelessWidget {
  const GenericChartOverlayText({
    super.key,
    required this.message,
    required this.height,
  });

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
