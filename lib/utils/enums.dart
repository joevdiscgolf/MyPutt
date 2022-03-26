import 'package:json_annotation/json_annotation.dart';

enum PerformanceViewMode { calendar, chart }

enum ChallengeResult { win, loss, draw, none }

enum ChallengeCategory { pending, active, complete, none }

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

enum ConditionsType { wind, weather, distance }

enum WindCondition {
  @JsonValue('Calm')
  calm,
  @JsonValue('Breezy')
  breezy,
  @JsonValue('Gusty')
  gusty,
  @JsonValue('Intense')
  intense
}

enum WeatherCondition {
  @JsonValue('Sunny')
  sunny,
  @JsonValue('Rainy')
  rainy,
  @JsonValue('Snowy')
  snowy
}

enum Circles {
  circle1,
  circle2,
}

enum LoginState { loggedIn, setup, none, forceUpgrade, error }

enum AppScreenState {
  loggedIn,
  notLoggedIn,
  setup,
  firstRun,
  forceUpgrade,
  error
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
