import 'package:flutter/material.dart';
import 'package:myputt/components/misc/animated_circular_progress_indicator.dart';

class PercentageColumn extends StatelessWidget {
  const PercentageColumn(
      {Key? key, required this.distance, required this.decimal, this.size = 30})
      : super(key: key);

  final int distance;
  final double decimal;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$distance ft'),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: size,
          width: size,
          child: TweenAnimationBuilder(
            curve: Curves.easeOutQuad,
            tween: Tween(begin: 0, end: decimal),
            duration: const Duration(milliseconds: 750),
            builder: (BuildContext context, num value, Widget? child) {
              return AnimatedCircularProgressIndicator(
                size: 30,
                strokeWidth: 2,
                duration: const Duration(milliseconds: 300),
                decimal: decimal,
                showText: false,
              );
            },
          ),
        )
      ],
    );
  }
}
