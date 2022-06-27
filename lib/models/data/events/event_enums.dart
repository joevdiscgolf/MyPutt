import 'package:json_annotation/json_annotation.dart';

enum Division {
  @JsonValue('mpo')
  mpo,
  @JsonValue('mp40')
  mp40,
  @JsonValue('mp50')
  mp50,
  @JsonValue('ma1')
  ma1,
  @JsonValue('ma2')
  ma2,
  @JsonValue('ma3')
  ma3,
  @JsonValue('ma4')
  ma4,
  @JsonValue('ma5')
  ma5,
  @JsonValue('fpo')
  fpo,
  @JsonValue('fa1')
  fa1,
  @JsonValue('fa2')
  fa2,
  @JsonValue('fa3')
  fa3,
  @JsonValue('junior')
  junior,
  @JsonValue('mixed')
  mixed,
}

enum EventType {
  @JsonValue('club')
  club,
  @JsonValue('tournament')
  tournament,
}

enum EventStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('active')
  active,
  @JsonValue('complete')
  complete,
}
