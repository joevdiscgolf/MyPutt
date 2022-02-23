import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_set.dart';

double dp(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
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
