// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myputt_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPuttUser _$MyPuttUserFromJson(Map json) => MyPuttUser(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      uid: json['uid'] as String,
      pdgaNum: json['pdgaNum'] as int,
    );

Map<String, dynamic> _$MyPuttUserToJson(MyPuttUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'displayName': instance.displayName,
      'uid': instance.uid,
      'pdgaNum': instance.pdgaNum,
    };
