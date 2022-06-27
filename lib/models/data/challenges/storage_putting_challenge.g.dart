// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoragePuttingChallenge _$StoragePuttingChallengeFromJson(Map json) =>
    StoragePuttingChallenge(
      status: json['status'] as String,
      creationTimeStamp: json['creationTimeStamp'] as int,
      completionTimeStamp: json['completionTimeStamp'] as int?,
      id: json['id'] as String,
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
      challengerSets: (json['challengerSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      recipientSets: (json['recipientSets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$StoragePuttingChallengeToJson(
        StoragePuttingChallenge instance) =>
    <String, dynamic>{
      'status': instance.status,
      'creationTimeStamp': instance.creationTimeStamp,
      'completionTimeStamp': instance.completionTimeStamp,
      'id': instance.id,
      'challengerUser': instance.challengerUser.toJson(),
      'recipientUser': instance.recipientUser?.toJson(),
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
      'challengerSets': instance.challengerSets.map((e) => e.toJson()).toList(),
      'recipientSets': instance.recipientSets.map((e) => e.toJson()).toList(),
    };
