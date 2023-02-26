import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/users/myputt_user.dart';

part 'user_endpoints.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetUserResponse {
  const GetUserResponse({this.user});
  final MyPuttUser? user;

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserResponseToJson(this);
}
