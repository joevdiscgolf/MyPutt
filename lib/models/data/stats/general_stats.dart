import 'package:json_annotation/json_annotation.dart';

part 'general_stats.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GeneralStats {
  GeneralStats({required this.totalAttempts, required this.totalMade});
  final int totalAttempts;
  final int totalMade;

  factory GeneralStats.fromJson(Map<String, dynamic> json) =>
      _$GeneralStatsFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralStatsToJson(this);
}
