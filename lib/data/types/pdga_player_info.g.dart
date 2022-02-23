// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdga_player_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDGAPlayerInfo _$PDGAPlayerInfoFromJson(Map json) => PDGAPlayerInfo(
      name: json['name'] as String?,
      pdgaNum: json['pdgaNum'] as int?,
      location: json['location'] as String?,
      classification: json['classification'] as String?,
      memberSince: json['memberSince'] as String?,
      rating: json['rating'] as int?,
      careerEarnings: (json['careerEarnings'] as num?)?.toDouble(),
      careerEvents: json['careerEvents'] as int?,
      nextEvent: json['nextEvent'] as String?,
      careerWins: json['careerWins'] as int?,
    );

Map<String, dynamic> _$PDGAPlayerInfoToJson(PDGAPlayerInfo instance) =>
    <String, dynamic>{
      'pdgaNum': instance.pdgaNum,
      'name': instance.name,
      'location': instance.location,
      'classification': instance.classification,
      'memberSince': instance.memberSince,
      'rating': instance.rating,
      'careerEvents': instance.careerEvents,
      'careerEarnings': instance.careerEarnings,
      'careerWins': instance.careerWins,
      'nextEvent': instance.nextEvent,
    };
