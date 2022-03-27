import 'package:intl/intl.dart';

int versionToNumber(String version) {
  final withoutDots = version.replaceAll(RegExp('\\.'), ''); // abc
  return int.parse(withoutDots);
}

List<String> getPrefixes(String str) {
  final String lowerCase = str.toLowerCase();
  final List<String> result = <String>[];

  if (lowerCase.isEmpty) {
    return result;
  }

  for (int i = 1; i <= lowerCase.length; i++) {
    result.add(lowerCase.substring(0, i));
  }
  return result;
}

String getMessageFromDifference(int difference) {
  if (difference > 0) {
    return 'Victory';
  } else if (difference < 0) {
    return 'Defeat';
  } else {
    return 'Draw';
  }
}

String timestampToDate(int timestamp) {
  return '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(timestamp)).toString()}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp)).toString()}';
}
