// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingChallenge _$PuttingChallengeFromJson(Map json) => PuttingChallenge(
      status: json['status'] as String,
      creationTimeStamp: json['creationTimeStamp'] as int,
      id: json['id'] as String,
      opponentUser: json['opponentUser'] == null
          ? null
          : MyPuttUser.fromJson(
              Map<String, dynamic>.from(json['opponentUser'] as Map)),
      currentUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['currentUser'] as Map)),
      challengerUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['challengerUser'] as Map)),
      recipientUser: json['recipientUser'] == null
          ? null
          : MyPuttUser.fromJson(
              Map<String, dynamic>.from(json['recipientUser'] as Map)),
      challengeStructure: (json['challengeStructure'] as List<dynamic>)
          .map((e) => ChallengeStructureItem.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      opponentSets: (json['opponentSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      currentUserSets: (json['currentUserSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      completionTimeStamp: json['completionTimeStamp'] as int?,
      isSynced: json['isSynced'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      currentUserSetsUpdatedAt: json['currentUserSetsUpdatedAt'] as String?,
      opponentSetsUpdatedAt: json['opponentSetsUpdatedAt'] as String?,
      challengerSetsUpdatedAt: json['challengerSetsUpdatedAt'] as String?,
      recipientSetsUpdatedAt: json['recipientSetsUpdatedAt'] as String?,
    );

Map<String, dynamic> _$PuttingChallengeToJson(PuttingChallenge instance) =>
    <String, dynamic>{
      'status': instance.status,
      'creationTimeStamp': instance.creationTimeStamp,
      'completionTimeStamp': instance.completionTimeStamp,
      'id': instance.id,
      'opponentUser': instance.opponentUser?.toJson(),
      'currentUser': instance.currentUser.toJson(),
      'challengerUser': instance.challengerUser.toJson(),
      'recipientUser': instance.recipientUser?.toJson(),
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
      'opponentSets': instance.opponentSets.map((e) => e.toJson()).toList(),
      'currentUserSets':
          instance.currentUserSets.map((e) => e.toJson()).toList(),
      'isSynced': instance.isSynced,
      'isDeleted': instance.isDeleted,
      'currentUserSetsUpdatedAt': instance.currentUserSetsUpdatedAt,
      'opponentSetsUpdatedAt': instance.opponentSetsUpdatedAt,
      'challengerSetsUpdatedAt': instance.challengerSetsUpdatedAt,
      'recipientSetsUpdatedAt': instance.recipientSetsUpdatedAt,
    };
