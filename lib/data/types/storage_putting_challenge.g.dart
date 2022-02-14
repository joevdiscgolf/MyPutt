// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoragePuttingChallenge _$StoragePuttingChallengeFromJson(Map json) =>
    StoragePuttingChallenge(
      status: _$enumDecode(_$ChallengeStatusEnumMap, json['status']),
      creationTimeStamp: json['creationTimeStamp'] as int,
      id: json['id'] as String,
      challengerUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['challengerUser'] as Map)),
      recipientUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['recipientUser'] as Map)),
      challengeStructureDistances:
          (json['challengeStructureDistances'] as List<dynamic>)
              .map((e) => e as int)
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
      'status': _$ChallengeStatusEnumMap[instance.status],
      'creationTimeStamp': instance.creationTimeStamp,
      'id': instance.id,
      'challengerUser': instance.challengerUser.toJson(),
      'recipientUser': instance.recipientUser.toJson(),
      'challengeStructureDistances': instance.challengeStructureDistances,
      'challengerSets': instance.challengerSets.map((e) => e.toJson()).toList(),
      'recipientSets': instance.recipientSets.map((e) => e.toJson()).toList(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ChallengeStatusEnumMap = {
  ChallengeStatus.pending: 'pending',
  ChallengeStatus.active: 'active',
  ChallengeStatus.complete: 'complete',
};
