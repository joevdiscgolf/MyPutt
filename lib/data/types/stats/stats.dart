import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/stats/general_stats.dart';

part 'stats.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Stats {
  Stats(
      {this.circleOnePercentages,
      this.circleTwoPercentages,
      this.circleOneOverall,
      this.circleTwoOverall,
      this.generalStats});

  final Map<int, num?>? circleOnePercentages;
  final Map<int, num?>? circleOneOverall;

  final Map<int, num?>? circleTwoPercentages;
  final Map<int, num?>? circleTwoOverall;

  final GeneralStats? generalStats;

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
