import 'dart:math';
import 'package:myputt/utils/constants.dart';

int getNextDistancePreset(int currentDistance, {required bool increase}) {
  // if larger than largest preset
  if (currentDistance >= kDistanceOptions.reduce(max)) {
    if (increase) {
      return currentDistance;
    } else {
      // decrement by one
      return kDistanceOptions[kDistanceOptions.length - 2];
    }
  }
  // smaller than smallest preset
  else if (currentDistance <= kDistanceOptions.reduce(min)) {
    if (increase) {
      return kDistanceOptions[1];
    } else {
      return currentDistance;
    }
  } else {
    late final int closestIndex;
    for (int i = 0; i < kDistanceOptions.length; i++) {
      if (kDistanceOptions[i] >= currentDistance) {
        closestIndex = i;
        break;
      }
    }
    if (increase) {
      if (closestIndex == kDistanceOptions.length - 1) {
        return kDistanceOptions.first;
      } else {
        return kDistanceOptions[closestIndex + 1];
      }
    } else {
      if (closestIndex == 0) {
        // cycle back around to largest
        return kDistanceOptions.last;
      } else {
        return kDistanceOptions[closestIndex - 1];
      }
    }
  }
}
