import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

// Bouncing scroll physics on the bottom and clamping on the top
class BottomBouncingScrollPhysics extends ScrollPhysics {
  const BottomBouncingScrollPhysics({
    this.decelerationRate = ScrollDecelerationRate.normal,
    super.parent,
  });

  final ScrollDecelerationRate decelerationRate;

  @override
  BottomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BottomBouncingScrollPhysics(
      parent: buildParent(ancestor),
      decelerationRate: decelerationRate,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              '$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.',
          ),
          DiagnosticsProperty<ScrollPhysics>(
              'The physics object in question was', this,
              style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<ScrollMetrics>(
              'The position object in question was', position,
              style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());

    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // Underscroll.

      // return clamping
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Overscroll.
      return 0;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge.

      // return clamping
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge.
      return 0;
    }
    return 0.0;
  }

  double frictionFactor(double overscrollFraction) {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return 0.07 * math.pow(1 - overscrollFraction, 2);
      case ScrollDecelerationRate.normal:
        return 0.52 * math.pow(1 - overscrollFraction, 2);
    }
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) {
      return offset;
    }

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) {
        return absDelta * gamma;
      }
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final Tolerance tolerance = toleranceFor(position);

    // bouncing for positive velocity
    double constantDeceleration;
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        constantDeceleration = 1400;
        break;
      case ScrollDecelerationRate.normal:
        constantDeceleration = 0;
        break;
    }

    if (velocity > 0) {
      if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
        return BouncingScrollSimulation(
          spring: spring,
          position: position.pixels,
          velocity: velocity,
          leadingExtent: position.minScrollExtent,
          trailingExtent: position.maxScrollExtent,
          tolerance: tolerance,
          constantDeceleration: constantDeceleration,
        );
      }
      return null;
    } else {
      // clamping scroll physics for negative velocity
      if (position.outOfRange) {
        double? end;
        if (position.pixels > position.maxScrollExtent) {
          end = position.maxScrollExtent;
        }
        if (position.pixels < position.minScrollExtent) {
          end = position.minScrollExtent;
        }
        assert(end != null);
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          end!,
          math.min(0.0, velocity),
          tolerance: tolerance,
        );
      }
      if (velocity.abs() < tolerance.velocity) {
        return null;
      }
      if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
        return null;
      }
      if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
        return null;
      }
      return ClampingScrollSimulation(
        position: position.pixels,
        velocity: velocity,
        tolerance: tolerance,
      );
    }
  }

  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  @override
  double get maxFlingVelocity {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return kMaxFlingVelocity * 8.0;
      case ScrollDecelerationRate.normal:
        return super.maxFlingVelocity;
    }
  }

  @override
  SpringDescription get spring {
    switch (decelerationRate) {
      case ScrollDecelerationRate.fast:
        return SpringDescription.withDampingRatio(
          mass: 0.3,
          stiffness: 75.0,
          ratio: 1.3,
        );
      case ScrollDecelerationRate.normal:
        return super.spring;
    }
  }
}
