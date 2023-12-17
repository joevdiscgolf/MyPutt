import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RingPathClipper extends CustomClipper<Path> {
  const RingPathClipper({required this.ringWidth});

  final double ringWidth;

  @override
  getClip(Size size) {
    final Path path = Path();
    path.moveTo(ringWidth, size.height / 2);
    path.lineTo(ringWidth, size.height);
    path.arcToPoint(Offset(size.width - ringWidth, size.height));
    path.lineTo(size.width - ringWidth, size.height / 2);
    path.arcToPoint(Offset(ringWidth, size.height / 2), rotation: 180);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class PathPainter extends CustomPainter {
  const PathPainter({
    required this.outerCircleRadius,
    required this.innerCircleRadius,
    required this.cartesianXIntersection,
    required this.sideAngleDegrees,
    this.hasTopPoint = false,
  });

  final double outerCircleRadius;
  final double innerCircleRadius;
  final double cartesianXIntersection;
  final double sideAngleDegrees;
  final bool hasTopPoint;

  double _toCartesianY(double y) {
    return outerCircleRadius - y;
  }

  double _fromCartesianY(double cartesianY) {
    return outerCircleRadius - cartesianY;
  }

  double _toCartesianX(double x) {
    return x - (outerCircleRadius);
  }

  double _fromCartesianX(double cartesianX) {
    return outerCircleRadius - cartesianX;
  }

  double _getYRingIntersection() {
    final double negativeYIntercept =
        -sqrt(pow(innerCircleRadius, 2) - pow(cartesianXIntersection, 2));

    return _fromCartesianY(negativeYIntercept);
  }

  double _getSlopeFromAngle() {
    final double sideAngleRadians = (90 - sideAngleDegrees) * (pi / 180);
    return tan(sideAngleRadians);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path path =
        hasTopPoint ? _getPointedPath(size) : _getRoundedPath(size);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  Path _getRoundedPath(Size size) {
    final Path path = Path();
    final Radius radius = Radius.circular(innerCircleRadius / 2);

    final double yInterSection = _getYRingIntersection();

    path.moveTo((size.width / 2) - cartesianXIntersection, yInterSection);
    path.lineTo((size.width / 2) - cartesianXIntersection, size.height);
    path.arcToPoint(
      Offset((size.width / 2) + cartesianXIntersection, size.height),
      radius: radius,
      clockwise: false,
    );
    path.lineTo((size.width / 2) + cartesianXIntersection, yInterSection);
    path.arcToPoint(
      Offset((size.width / 2) - cartesianXIntersection, yInterSection),
      radius: radius,
    );
    return path;
  }

  Path _getPointedPath(Size size) {
    // positive slope on left side, negative on right side
    final Offset pathOrigin = Offset(size.width / 2, size.height / 2);
    const Offset cartesianOrigin = Offset.zero;

    final double slope = _getSlopeFromAngle();
    final double yIntercept = _getYIntercept(slope, cartesianOrigin);

    final List<double> circleCollisions =
        getCircleCollisions(slope, outerCircleRadius, yIntercept);

    final double? positiveCircleSolutionX =
        circleCollisions.firstWhereOrNull((collision) => collision > 0);

    if (positiveCircleSolutionX == null) {
      return Path();
    }

    final double negativeYInterception =
        _getYForCircleX(positiveCircleSolutionX, outerCircleRadius);

    final Offset firstCartesianArcPoint = Offset(
      -positiveCircleSolutionX,
      negativeYInterception,
    );
    final Offset secondCartesianArcPoint = Offset(
      positiveCircleSolutionX,
      negativeYInterception,
    );

    final Offset firstArcPoint = Offset(
      _fromCartesianX(firstCartesianArcPoint.dx),
      _fromCartesianY(firstCartesianArcPoint.dy),
    );
    final Offset secondArcPoint = Offset(
      _fromCartesianX(secondCartesianArcPoint.dx),
      _fromCartesianY(secondCartesianArcPoint.dy),
    );

    print('first arc point: $firstCartesianArcPoint');

    final Path path = Path();
    // go to cartesian origin
    path.moveTo(pathOrigin.dx, pathOrigin.dy);
    path.lineTo(firstArcPoint.dx, firstArcPoint.dy);
    path.arcToPoint(
      secondArcPoint,
      radius: Radius.circular(outerCircleRadius),
    );
    path.lineTo(pathOrigin.dx, pathOrigin.dy);

    return path;
  }

  double _getYIntercept(double slope, Offset point) {
    // y = mx + b,  b = y - mx
    return point.dy - (slope * point.dx);
  }

  double _getYForCircleX(double x, double radius) {
    // x^2 + y^2 = r^2, y = sqrt(r^2 - x^2)
    return -sqrt(pow(radius, 2) - pow(x, 2));
  }

  List<double> getCircleCollisions(
    double slope,
    double radius,
    double yIntercept,
  ) {
    final num aPrime = 1 + pow(slope, 2); // a' = 1 + m^2
    final num bPrime = 2 * slope * yIntercept; // b' = 2mb
    final num cPrime = pow(yIntercept, 2) - pow(radius, 2);

    final num discriminant = pow(bPrime, 2) - 4 * aPrime * cPrime;

    // no solution
    if (discriminant < 0) {
      return [];
    }

    final double positiveSolution =
        (-bPrime + sqrt(pow(bPrime, 2) - (4 * aPrime * cPrime))) / (2 * aPrime);

    if (discriminant == 0) {
      return [positiveSolution];
    } else {
      final double negativeSolution =
          (-bPrime - sqrt(pow(bPrime, 2) - (4 * aPrime * cPrime))) /
              (2 * aPrime);
      return [positiveSolution, negativeSolution];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
