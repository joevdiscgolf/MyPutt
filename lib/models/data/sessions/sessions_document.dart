import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';

part 'sessions_document.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class SessionsDocument {
  SessionsDocument({this.currentSession});
  final PuttingSession? currentSession;

  factory SessionsDocument.fromJson(Map<String, dynamic> json) =>
      _$SessionsDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$SessionsDocumentToJson(this);
}
