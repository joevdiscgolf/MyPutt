import 'package:json_annotation/json_annotation.dart';

enum WindConditions {
  @JsonValue('calm')
  calm,
  @JsonValue('breezy')
  breezy,
  @JsonValue('strong')
  strong,
  @JsonValue('violent')
  violent,
}

enum WindDirection {
  @JsonValue('headwind')
  headwind,
  @JsonValue('tailwind')
  tailwind,
  @JsonValue('leftToRight')
  leftToRight,
  @JsonValue('rightToLeft')
  rightToLeft,
}

enum WeatherConditions {
  sunny,
  cloudy,
  rainy,
  snowy,
}
