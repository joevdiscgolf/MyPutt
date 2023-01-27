import 'package:json_annotation/json_annotation.dart';

part 'app_info_endpoints.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetMinimumVersionResponse {
  const GetMinimumVersionResponse({this.minimumVersion});

  final String? minimumVersion;

  factory GetMinimumVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMinimumVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMinimumVersionResponseToJson(this);
}
