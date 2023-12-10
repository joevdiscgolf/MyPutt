import 'dart:math';
import 'package:myputt/utils/constants.dart';

int getNextDistancePreset(int currentDistance, {required bool increase}) {
  // if larger than largest preset
  if (currentDistance > kDefaultDistanceOptions.reduce(max)) {
    if (increase) {
      return currentDistance;
    } else {
      // set to largest distance option
      return kDefaultDistanceOptions[kDefaultDistanceOptions.length - 1];
    }
  }

  // smaller than smallest preset
  else if (currentDistance < kDefaultDistanceOptions.reduce(min)) {
    // set to smallest distance option
    if (increase) {
      return kDefaultDistanceOptions[0];
    } else {
      return currentDistance;
    }
  }
  // within the presets
  else {
    int? index;
    if (increase) {
      for (int i = 0; i < kDefaultDistanceOptions.length; i++) {
        final int distance = kDefaultDistanceOptions[i];
        if (distance > currentDistance) {
          index = i;
          break;
        }
      }
    } else {
      for (int i = kDefaultDistanceOptions.length - 1; i >= 0; i--) {
        final int distance = kDefaultDistanceOptions[i];
        if (distance < currentDistance) {
          index = i;
          break;
        }
      }
    }

    if (index != null) {
      return kDefaultDistanceOptions[index];
    } else {
      return currentDistance;
    }
  }
}

int getUpdatedSetLength(int currentSetLength, bool increase) {
  if (increase) {
    return currentSetLength + 1;
  } else if (currentSetLength == 1) {
    return 1;
  } else {
    return currentSetLength - 1;
  }
}
