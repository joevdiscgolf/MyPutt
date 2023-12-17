import 'package:flutter/material.dart';
import 'package:myputt/components/circle_diagram/ring_path_clipper.dart';

class CircleDiagram extends StatelessWidget {
  const CircleDiagram({super.key});

  static const double outerRadius = 100;

  @override
  Widget build(BuildContext context) {
    const double segmentHeight = outerRadius / 3;
    return Stack(
      children: [
        Container(
          color: Colors.blue.withOpacity(0.5),
          height: outerRadius * 2,
          width: outerRadius * 2,
          child: const CustomPaint(
            painter: PathPainter(
              innerCircleRadius: segmentHeight,
              outerCircleRadius: outerRadius,
              cartesianXIntersection: 20,
              sideAngleDegrees: 30,
              hasTopPoint: true,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, segmentHeight),
          child: Container(
            color: Colors.green.withOpacity(0.5),
            height: outerRadius * 2,
            width: outerRadius * 2,
            child: CustomPaint(
              painter: PathPainter(
                innerCircleRadius: outerRadius * 0.75,
                outerCircleRadius: outerRadius,
                cartesianXIntersection: 30,
                sideAngleDegrees: 20,
                hasTopPoint: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
