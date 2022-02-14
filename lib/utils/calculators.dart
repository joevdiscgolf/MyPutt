import 'dart:ui';

import 'package:flutter/material.dart';

int totalPuttsMade() {
  return 5;
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
