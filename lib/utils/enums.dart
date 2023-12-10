import 'package:json_annotation/json_annotation.dart';

enum PerformanceViewMode { calendar, chart }

enum ChallengeResult { win, loss, draw }

enum ChallengeCategory { pending, active, complete }

enum ChallengePreset {
  @JsonValue('Circle 1 basics')
  c1Basics,
  @JsonValue('20-footer clinic')
  twentyFooterClinic,
  @JsonValue('Step putt station')
  stepPuttStation,
  @JsonValue('none')
  none,
}

enum WeatherCondition {
  @JsonValue('Sunny')
  sunny,
  @JsonValue('Rainy')
  rainy,
  @JsonValue('Snowy')
  snowy
}

enum PuttingCircle {
  c1,
  c1x,
  c2,
  c3,
}

enum FrisbeeIconColor {
  @JsonValue('red')
  red,
  @JsonValue('green')
  green,
  @JsonValue('blue')
  blue,
  @JsonValue('purple')
  purple,
  @JsonValue('pink')
  pink
}
