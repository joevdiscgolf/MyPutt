import 'package:json_annotation/json_annotation.dart';

enum ChartRange {
  @JsonValue('last_five')
  lastFive,
  @JsonValue('last_twenty')
  lastTwenty,
  @JsonValue('last_fifty')
  lastFifty,
  @JsonValue('all')
  all,
}
