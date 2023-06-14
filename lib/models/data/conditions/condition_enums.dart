import 'package:json_annotation/json_annotation.dart';

enum WindIntensity {
  @JsonValue('calm')
  calm,
  @JsonValue('breezy')
  breezy,
  @JsonValue('strong')
  strong,
  @JsonValue('intense')
  intense,
}

enum WindDirection {
  @JsonValue('headwind')
  headwind,
  @JsonValue('tailwind')
  tailwind,
  @JsonValue('ltr_cross')
  ltrCross,
  @JsonValue('rtl_cross')
  rtlCross
}

enum WeatherConditions {
  @JsonValue('sunny')
  sunny,
  @JsonValue('cloudy')
  cloudy,
  @JsonValue('rainy')
  rainy,
  @JsonValue('snowy')
  snowy,
}

enum PuttingStance {
  @JsonValue('staggered')
  staggered,
  @JsonValue('straddle')
  straddle,
}
