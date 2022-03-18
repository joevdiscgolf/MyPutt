import 'package:json_annotation/json_annotation.dart';

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

enum Circles {
  circle1,
  circle2,
}

enum LoginState { loggedIn, setup, none, forceUpgrade, error }

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
