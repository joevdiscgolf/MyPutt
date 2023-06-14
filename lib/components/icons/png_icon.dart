import 'dart:math' as math;
import 'package:flutter/material.dart';

class PngIcon extends StatelessWidget {
  const PngIcon({
    Key? key,
    required this.path,
    required this.size,
    this.flipHorizontal = false,
  }) : super(key: key);

  final String path;
  final double size;
  final bool flipHorizontal;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(
        flipHorizontal ? math.pi : 0,
      ),
      child: SizedBox(
        height: size,
        width: size,
        child: Image.asset(
          path,
          height: size,
          width: size,
          errorBuilder: (context, e, trace) {
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
