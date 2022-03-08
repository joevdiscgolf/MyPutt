import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/chart/chart_point.dart';

PerformanceChartData smoothChart(
    PerformanceChartData data, int comparisonRange) {
  final List<ChartPoint> points = data.points;
  if (comparisonRange == 0) {
    return PerformanceChartData(points: points);
  }
  final List<ChartPoint> newPoints = [];
  for (int index = 0; index < points.length; index++) {
    if (index == 0 || index == points.length - 1) {
      newPoints.add(points[index]);
    } else {
      final double avgAdjacent =
          weightedAverageOfAdjacent(points, comparisonRange, index);
      newPoints.add(ChartPoint(
          distance: points[index].distance,
          decimal: avgAdjacent,
          timeStamp: points[index].timeStamp,
          index: index));
    }
  }
  return PerformanceChartData(points: newPoints);
}

double weightedAverageOfAdjacent(
    List<ChartPoint> points, int range, int focusIndex) {
  double sumOfWeightings = 0;
  double weightedTotal = 0;
  sumOfWeightings *= 2;
  for (var index = 1; index < range + 1; index++) {
    if (focusIndex - index < 0) {
      break;
    } else {
      num weighting = range - (index - 1);
      sumOfWeightings += weighting;
      weightedTotal += weighting * points[focusIndex - index].decimal;
    }
  }

  for (var index = 1; index < range + 1; index++) {
    if (focusIndex + index > points.length - 1) {
      break;
    } else {
      num weighting = range - (index - 1);
      sumOfWeightings += weighting;
      weightedTotal += weighting * points[focusIndex + index].decimal;
    }
  }
  return sumOfWeightings.toDouble() == 0
      ? 1
      : double.parse((weightedTotal.toDouble() / sumOfWeightings.toDouble())
          .toStringAsFixed(4));
}

Color colorFromDecimal(double decimal) {
  final color = Color.fromARGB(255, redFromDecimal(decimal),
      greenFromDecimal(decimal), blueFromDecimal(decimal));
  return color;
}

int redFromDecimal(double decimal) {
  if (decimal < 0.7) {
    return 255;
  } else {
    return (-850 * decimal + 850).toInt();
  }
}

int greenFromDecimal(double decimal) {
  if (decimal < 0.5) {
    return (266 * decimal + 89).toInt();
  } else {
    return 222;
  }
}

int blueFromDecimal(double decimal) {
  if (decimal < 0.7) {
    return 84;
  } else {
    return (33 * decimal).toInt();
  }
}

int totalMadeFromSets(List<PuttingSet> sets) {
  int total = 0;
  for (var set in sets) {
    total += set.puttsMade.toInt();
  }
  return total;
}

int totalAttemptsFromSets(List<PuttingSet> sets) {
  int total = 0;
  for (var set in sets) {
    total += set.puttsAttempted.toInt();
  }
  return total;
}

int totalMadeFromSubset(List<PuttingSet> sets, int limit) {
  int total = 0;
  for (int i = 0; i < limit; i++) {
    total += sets[i].puttsMade.toInt();
  }
  return total;
}

int totalAttemptsFromSubset(List<PuttingSet> sets, int limit) {
  int total = 0;
  for (int i = 0; i < limit; i++) {
    total += sets[i].puttsAttempted.toInt();
  }
  return total;
}

int totalAttemptsFromStructure(List<ChallengeStructureItem> structure) {
  int total = 0;
  for (var item in structure) {
    total += item.setLength;
  }
  return total;
}
