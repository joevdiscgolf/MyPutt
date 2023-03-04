part of 'record_cubit.dart';

@immutable
abstract class RecordState {
  const RecordState();
}

class RecordInitial extends RecordState {
  const RecordInitial();
}

class RecordActive extends RecordState {
  const RecordActive({
    required this.distance,
    required this.setLength,
    required this.puttsSelected,
    required this.sslKey,
    this.stance,
    this.weatherConditions,
  });
  final int distance;
  final int setLength;
  final int puttsSelected;
  final GlobalKey<ScrollSnapListState> sslKey;
  final PuttingStance? stance;
  final WeatherConditions? weatherConditions;
  RecordActive copyWith({
    int? distance,
    int? setLength,
    int? puttsSelected,
    GlobalKey<ScrollSnapListState>? sslKey,
    PuttingStance? stance,
    WeatherConditions? weatherConditions,
  }) {
    return RecordActive(
      distance: distance ?? this.distance,
      setLength: setLength ?? this.setLength,
      puttsSelected: puttsSelected ?? this.puttsSelected,
      sslKey: sslKey ?? this.sslKey,
      stance: stance ?? this.stance,
      weatherConditions: weatherConditions ?? this.weatherConditions,
    );
  }
}
