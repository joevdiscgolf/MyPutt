// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingChallenge _$PuttingChallengeFromJson(Map json) => PuttingChallenge(
      status: _$enumDecode(_$ChallengeStatusEnumMap, json['status']),
      creationTimeStamp: json['creationTimeStamp'] as int,
      id: json['id'] as String,
      opponentUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['opponentUser'] as Map)),
      currentUser: MyPuttUser.fromJson(
          Map<String, dynamic>.from(json['currentUser'] as Map)),
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
      'status': _$ChallengeStatusEnumMap[instance.status],
      'creationTimeStamp': instance.creationTimeStamp,
      'id': instance.id,
      'opponentUser': instance.opponentUser.toJson(),
      'currentUser': instance.currentUser.toJson(),
      'challengeStructureDistances': instance.challengeStructureDistances,
      'opponentSets': instance.opponentSets.map((e) => e.toJson()).toList(),
      'currentUserSets':
          instance.currentUserSets.map((e) => e.toJson()).toList(),
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
