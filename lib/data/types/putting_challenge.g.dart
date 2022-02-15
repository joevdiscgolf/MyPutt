// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingChallenge _$PuttingChallengeFromJson(Map json) => PuttingChallenge(
      status: json['status'] as String,
      creationTimeStamp: json['creationTimeStamp'] as int,
      id: json['id'] as String,
      opponentUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['opponentUser'] as Map)),
      currentUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['currentUser'] as Map)),
      challengerUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['challengerUser'] as Map)),
      recipientUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['recipientUser'] as Map)),
      challengeStructureDistances:
          (json['challengeStructureDistances'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
      opponentSets: (json['opponentSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      currentUserSets: (json['currentUserSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$PuttingChallengeToJson(PuttingChallenge instance) =>
    <String, dynamic>{
      'status': instance.status,
      'creationTimeStamp': instance.creationTimeStamp,
      'id': instance.id,
      'opponentUser': instance.opponentUser.toJson(),
      'currentUser': instance.currentUser.toJson(),
      'challengerUser': instance.challengerUser.toJson(),
      'recipientUser': instance.recipientUser.toJson(),
      'challengeStructureDistances': instance.challengeStructureDistances,
      'opponentSets': instance.opponentSets.map((e) => e.toJson()).toList(),
      'currentUserSets':
          instance.currentUserSets.map((e) => e.toJson()).toList(),
    };
