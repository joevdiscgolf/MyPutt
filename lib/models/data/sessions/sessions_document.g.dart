// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionsDocument _$SessionsDocumentFromJson(Map json) => SessionsDocument(
      currentSession: json['currentSession'] == null
          ? null
          : PuttingSession.fromJson(
              Map<String, dynamic>.from(json['currentSession'] as Map)),
    );

Map<String, dynamic> _$SessionsDocumentToJson(SessionsDocument instance) =>
    <String, dynamic>{
      'currentSession': instance.currentSession?.toJson(),
    };
