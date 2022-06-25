// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myputt_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPuttUser _$MyPuttUserFromJson(Map json) => MyPuttUser(
      username: json['username'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      displayName: json['displayName'] as String,
      uid: json['uid'] as String,
      pdgaNum: json['pdgaNum'] as int?,
      pdgaRating: json['pdgaRating'] as int?,
      frisbeeAvatar: json['frisbeeAvatar'] == null
          ? null
          : FrisbeeAvatar.fromJson(
              Map<String, dynamic>.from(json['frisbeeAvatar'] as Map)),
      userSettings: json['userSettings'] == null
          ? null
          : UserSettings.fromJson(
              Map<String, dynamic>.from(json['userSettings'] as Map)),
      eventIds: (json['eventIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isAdmin: json['isAdmin'] as bool?,
      trebuchets: (json['trebuchets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MyPuttUserToJson(MyPuttUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'keywords': instance.keywords,
      'displayName': instance.displayName,
      'uid': instance.uid,
      'pdgaNum': instance.pdgaNum,
      'pdgaRating': instance.pdgaRating,
      'frisbeeAvatar': instance.frisbeeAvatar?.toJson(),
      'userSettings': instance.userSettings?.toJson(),
      'eventIds': instance.eventIds,
      'isAdmin': instance.isAdmin,
      'trebuchets': instance.trebuchets,
    };

MyPuttUserMetadata _$MyPuttUserMetadataFromJson(Map json) => MyPuttUserMetadata(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      uid: json['uid'] as String,
      pdgaNum: json['pdgaNum'] as int?,
      pdgaRating: json['pdgaRating'] as int?,
      frisbeeAvatar: json['frisbeeAvatar'] == null
          ? null
          : FrisbeeAvatar.fromJson(
              Map<String, dynamic>.from(json['frisbeeAvatar'] as Map)),
    );

Map<String, dynamic> _$MyPuttUserMetadataToJson(MyPuttUserMetadata instance) =>
    <String, dynamic>{
      'username': instance.username,
      'displayName': instance.displayName,
      'uid': instance.uid,
      'pdgaNum': instance.pdgaNum,
      'pdgaRating': instance.pdgaRating,
      'frisbeeAvatar': instance.frisbeeAvatar?.toJson(),
    };
