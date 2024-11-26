import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myputt/components/circle_diagram/ring_path_clipper.dart';
import 'package:myputt/utils/enums.dart';

const Map<PuttingCircle, List<double>> kOuterRadiiForCircle = {
  PuttingCircle.c1: [0, 25, 50, 75],
  PuttingCircle.c2: [100, 125, 150, 175],
  PuttingCircle.c3: [200, 225, 250, 275],
};

class CircleDiagram extends StatelessWidget {
  const CircleDiagram({super.key, required this.circle});

  final PuttingCircle circle;

  @override
  Widget build(BuildContext context) {
    final List<double> outerRadii = kOuterRadiiForCircle[circle]!;
    return Stack(
      alignment: Alignment.center,
      children: [for (int i = 1; i < outerRadii.length; i++) i].map(
        (int index) {
          final double outerRadius = outerRadii[index] / 1.5;
          final double innerRadius = outerRadii[max(0, index - 1)] / 1.5;

          return Transform.translate(
            offset: const Offset(0, 0),
            child: Container(
              color: Colors.blue.withOpacity(0.3),
              height: outerRadius * 2,
              width: outerRadius * 2,
              child: CustomPaint(
                painter: PathPainter(
                  innerCircleRadius: innerRadius,
                  outerCircleRadius: outerRadius,
                  cartesianXIntersection: 20,
                  sideAngleDegrees: 30,
                  hasTopPoint: index == 1 && circle == PuttingCircle.c1,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
