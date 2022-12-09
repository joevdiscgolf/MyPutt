import 'package:myputt/utils/constants.dart';

int findNextIndexInDistanceList(int currentDistance, bool incremented) {
  for (int i = 0; i < kDistanceOptions.length; i++) {
    final int distance = kDistanceOptions[i];
    if (incremented && distance > currentDistance) {
      return i;
    } else if (!incremented && distance < currentDistance) {
      return i;
    }
  }
  if (incremented) {
    return 0;
  } else {
    return kDistanceOptions[kDistanceOptions.length - 1];
  }
}
