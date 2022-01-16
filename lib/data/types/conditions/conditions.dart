class Conditions {
  Conditions({required this.windConditions, required this.weatherConditions});
  final WindConditions windConditions;
  final WeatherConditions weatherConditions;
}

enum WindConditions {
  CALM,
  BREEZY,
  STRONG,
  INTENSE,
}

enum WeatherConditions {
  SUNNY,
  CLOUDY,
  RAINY,
  SNOWY,
}
