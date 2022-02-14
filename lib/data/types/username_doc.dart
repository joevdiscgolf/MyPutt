import 'package:json_annotation/json_annotation.dart';
part 'username_doc.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class UsernameDoc {
  UsernameDoc({required this.username, required this.uid});
  final String username;
  final String uid;

  factory UsernameDoc.fromJson(Map<String, dynamic> json) =>
      _$UsernameDocFromJson(json);

  Map<String, dynamic> toJson() => _$UsernameDocToJson(this);
}
