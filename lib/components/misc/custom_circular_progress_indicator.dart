import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    Key? key,
    required this.percentage,
    this.size = 52,
    this.color,
  }) : super(key: key);

  final double percentage;
  final double size;
  final Color? color;

  static const double _strokeWidth = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: size + _strokeWidth,
            width: size + _strokeWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  color: MyPuttColors.black.withValues(alpha: 0.25),
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MyPuttColors.gray[300],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: size,
            width: size,
            child: Transform.rotate(
              angle: -math.pi * percentage,
              child: CircularProgressIndicator(
                strokeWidth: _strokeWidth,
                value: percentage,
                color: color ?? MyPuttColors.blue,
                backgroundColor: MyPuttColors.gray[200],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: size - _strokeWidth,
            width: size - _strokeWidth,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyPuttColors.white,
            ),
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MyPuttColors.gray[300],
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
