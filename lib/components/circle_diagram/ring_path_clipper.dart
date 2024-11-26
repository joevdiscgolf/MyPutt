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
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }

  Path _getRoundedPath(Size size) {
    final Path path = Path();

    // y-intercept is 0 because the line passes through the origin
    final double slope = _getSlopeFromAngle();

    final List<double> innerCircleCollisions =
        getCircleCollisions(slope, innerCircleRadius, 0);
    final List<double> outerCircleCollisions =
        getCircleCollisions(slope, outerCircleRadius, 0);

    final double? positiveInnerCircleSolutionX =
        innerCircleCollisions.firstWhereOrNull((collision) => collision > 0);
    final double? positiveOuterCircleSolutionX =
        outerCircleCollisions.firstWhereOrNull((collision) => collision > 0);

    if (positiveInnerCircleSolutionX == null ||
        positiveOuterCircleSolutionX == null) {
      return Path();
    }

    final double negativeYInnerInterception =
        _getYForCircleX(positiveInnerCircleSolutionX, innerCircleRadius);
    final double negativeYOuterInterception =
        _getYForCircleX(positiveOuterCircleSolutionX, outerCircleRadius);

    final Offset firstPoint = Offset(
      _fromCartesianX(-positiveInnerCircleSolutionX),
      _fromCartesianY(negativeYInnerInterception),
    );
    final Offset secondPoint = Offset(
      _fromCartesianX(-positiveOuterCircleSolutionX),
      _fromCartesianY(negativeYOuterInterception),
    );
    final Offset thirdPoint = Offset(
      _fromCartesianX(positiveOuterCircleSolutionX),
      _fromCartesianY(negativeYOuterInterception),
    );
    final Offset fourthPoint = Offset(
      _fromCartesianX(positiveInnerCircleSolutionX),
      _fromCartesianY(negativeYInnerInterception),
    );

    path.moveTo(firstPoint.dx, firstPoint.dy);
    path.lineTo(secondPoint.dx, secondPoint.dy);
    path.arcToPoint(
      thirdPoint,
      radius: Radius.circular(outerCircleRadius),
      clockwise: true,
    );
    path.lineTo(fourthPoint.dx, fourthPoint.dy);
    path.arcToPoint(
      firstPoint,
      radius: Radius.circular(innerCircleRadius),
      clockwise: false,
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
