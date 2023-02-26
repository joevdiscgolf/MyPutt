// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_endpoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserResponse _$GetUserResponseFromJson(Map json) => GetUserResponse(
      user: json['user'] == null
          ? null
          : MyPuttUser.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
    );

Map<String, dynamic> _$GetUserResponseToJson(GetUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
    };
