import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/general_stats.dart';

part 'stats.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Stats {
  Stats(
      {this.circleOnePercentages,
      this.circleOneAverages,
      this.circleTwoAverages,
      this.circleTwoPercentages,
      this.generalStats});

  final Map<int, double>? circleOnePercentages;
  final Map<int, double>? circleOneAverages;

  final Map<int, double>? circleTwoPercentages;
  final Map<int, double>? circleTwoAverages;

  final GeneralStats? generalStats;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
/*
class CircleOneStats {
  CircleOneStats({ this.circleOnePercentages});
  final Map<int, double> circleOnePercentages;
}

class CircleTwoStats {
  CircleTwoStats({ this.circleTwoPercentages});
  final Map<int, double> circleTwoPercentages;
}*/
