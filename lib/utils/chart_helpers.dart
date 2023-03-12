import 'package:flutter/material.dart';
import 'package:myputt/models/data/chart/chart_point.dart';

class ChartHelpers {
  static double getDateScrubberHorizontalOffset(
    Offset dragOffset,
    double chartWidth,
    double scrubberHorizontalPadding, {
    required double scrubberWidth,
  }) {
    final double distanceToLeftEdge = dragOffset.dx - scrubberWidth / 2;
    final double distanceToRightEdge =
        chartWidth - dragOffset.dx - scrubberWidth / 2;
    if (distanceToLeftEdge < scrubberHorizontalPadding) {
      return scrubberHorizontalPadding - distanceToLeftEdge;
    } else if (distanceToRightEdge < scrubberHorizontalPadding) {
      return distanceToRightEdge - scrubberHorizontalPadding;
    } else {
      return 0;
    }
  }

  static double getPointIndexDecimal(
    double horizontalOffset,
    int numPoints,
    double chartWidth,
  ) {
    final double fractionOfWidth = horizontalOffset / chartWidth;
    return (numPoints - 1) * fractionOfWidth;
  }

  static double valueBetweenPoints(
    double remainder,
    int lowIndex,
    int highIndex,
    List<ChartPoint> points,
  ) {
    final double lowIndexValue = points[lowIndex].decimal;
    final double highIndexValue = points[highIndex].decimal;
    final double difference = highIndexValue - lowIndexValue;
    final double pointValue = lowIndexValue + (difference * remainder);
    return pointValue;
  }
}
