import 'package:json_annotation/json_annotation.dart';

enum ChallengeResult { win, loss, draw }

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

enum LoginState { loggedIn, setup, none, forceUpgrade, error }
