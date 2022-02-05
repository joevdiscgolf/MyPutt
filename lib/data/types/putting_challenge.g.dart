// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingChallenge _$PuttingChallengeFromJson(Map json) => PuttingChallenge(
      status: _$enumDecode(_$ChallengeStatusEnumMap, json['status']),
      createdAt: json['createdAt'] as int,
      id: json['id'] as String,
      challengerUid: json['challengerUid'] as String,
      currentUid: json['currentUid'] as String,
      challengeStructureDistances:
          (json['challengeStructureDistances'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
      challengerSets: (json['challengerSets'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      currentUserSets: (json['currentUserSets'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$PuttingChallengeToJson(PuttingChallenge instance) =>
    <String, dynamic>{
      'status': _$ChallengeStatusEnumMap[instance.status],
      'createdAt': instance.createdAt,
      'id': instance.id,
      'challengerUid': instance.challengerUid,
      'currentUid': instance.currentUid,
      'challengeStructureDistances': instance.challengeStructureDistances,
      'challengerSets': instance.challengerSets,
      'currentUserSets': instance.currentUserSets,
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
