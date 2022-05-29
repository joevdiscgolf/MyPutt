import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/utils/colors.dart';

import 'enums.dart';

class TimeRange {
  static const lastFive = 5;
  static const lastTwenty = 20;
  static const lastFifty = 50;
  static const allTime = 0;
}

class ChallengeStatus {
  static String pending = 'pending';
  static String active = 'active';
  static String complete = 'complete';
}

class Cutoffs {
  static const int c1x = 11;
  static const int c2 = 33;
  static const int none = 0;
}

const List<WindCondition> windConditions = [
  WindCondition.calm,
  WindCondition.breezy,
  WindCondition.gusty,
  WindCondition.intense,
];

const Map<WindCondition, String> windConditionsEnumMap = {
  WindCondition.calm: 'Calm',
  WindCondition.breezy: 'Breezy',
  WindCondition.gusty: 'Gusty',
  WindCondition.intense: 'Intense',
};

const List<WeatherCondition> weatherConditions = [
  WeatherCondition.sunny,
  WeatherCondition.rainy,
  WeatherCondition.snowy,
];

const Map<WeatherCondition, String> weatherConditionsEnumMap = {
  WeatherCondition.sunny: 'Sunny',
  WeatherCondition.rainy: 'Rainy',
  WeatherCondition.snowy: 'Snowy',
};

const List<int> distanceOptions = [10, 15, 20, 25, 30, 40, 50, 60];

const Map<int, int> distanceToIndex = {
  10: 0,
  15: 1,
  20: 2,
  25: 3,
  30: 4,
  40: 5,
  50: 6,
  60: 7
};

const Map<int, int> indexToTimeRange = {
  0: TimeRange.lastFive,
  1: TimeRange.lastTwenty,
  2: TimeRange.lastFifty,
  3: TimeRange.allTime,
};

const Map<ChallengePreset, String> challengePresetToText = {
  ChallengePreset.c1Basics: 'Circle 1 basics',
  ChallengePreset.stepPuttStation: 'Step putt station',
  ChallengePreset.twentyFooterClinic: '20-footer clinic'
};

const List<String> victorySubtitles = [
  "You're on fire 🔥",
  "McBeast mode 🐐",
  "Give someone else a chance 😜",
  "Hey, shouldn't you be on tour? 🥏",
  "Ice in your veins 🥶"
];

const List<String> defeatSubtitles = [
  "Aw shucks! Putter got cold? 🧊",
  "Someone has the yips 🥴",
  "Blame it on the frisbee 🥏",
  "You just got Ulied 😞",
  "Maybe you should buy more discs 💰"
];

const Map<FrisbeeIconColor, String> frisbeeIconColorToSrc = {
  FrisbeeIconColor.pink: pinkFrisbeeIconSrc,
  FrisbeeIconColor.purple: purpleFrisbeeIconSrc,
  FrisbeeIconColor.blue: blueFrisbeeIconSrc,
  FrisbeeIconColor.green: greenFrisbeeIconSrc,
  FrisbeeIconColor.red: redFrisbeeIconSrc,
};

const Map<FrisbeeIconColor, Color> frisbeeIconColorToColor = {
  FrisbeeIconColor.pink: MyPuttColors.pink,
  FrisbeeIconColor.purple: MyPuttColors.purple,
  FrisbeeIconColor.blue: MyPuttColors.blue,
  FrisbeeIconColor.green: MyPuttColors.green,
  FrisbeeIconColor.red: MyPuttColors.red,
};

const List<Color> backgroundAvatarColors = [
  MyPuttColors.pink,
  MyPuttColors.purple,
  MyPuttColors.blue,
  MyPuttColors.green,
  MyPuttColors.red,
];

const String blueFrisbeeIconSrc = 'assets/icons/frisbee_emoji_blue.png';
const String redFrisbeeIconSrc = 'assets/icons/frisbee_emoji_red.png';
const String purpleFrisbeeIconSrc = 'assets/icons/frisbee_emoji_purple.png';
const String greenFrisbeeIconSrc = 'assets/icons/frisbee_emoji_green.png';
const String pinkFrisbeeIconSrc = 'assets/icons/frisbee_emoji_pink.png';

const blueFrisbeeImageIcon = SizedBox(
  height: 20,
  width: 20,
  child: Image(
    image: AssetImage('assets/icons/frisbee_emoji_blue.png'),
  ),
);
const redFrisbeeImageIcon = SizedBox(
  height: 20,
  width: 20,
  child: Image(
    image: AssetImage('assets/icons/frisbee_emoji_red.png'),
  ),
);

final kTestEvents = [
  MyPuttEvent(
      eventId: 'e08d36dc-5df4-411d-9d26-8e68122044bb',
      code: 123,
      name: 'Summer Sizzler',
      challengeStructure: [ChallengeStructureItem(distance: 10, setLength: 10)],
      divisions: [Division.mpo, Division.fpo, Division.ma1, Division.fa1],
      eventType: EventType.tournament,
      endTimestamp: 1651109507018,
      startTimestamp: 1650945600000,
      status: EventStatus.active,
      verificationRequired: false,
      completionTimestamp: 2)
];

const Map<EventType, String> eventTypeToName = {
  EventType.club: 'Club',
  EventType.tournament: 'Tournament'
};

const defaultEventImgSrc =
    'https://www.discgolfpark.com/wp-content/uploads/2018/04/simon_putt.jpg';

const defaultEventImgPath = 'assets/images/simon_putt_bg.jpeg';

const List<Division> proDivisions = [
  Division.mpo,
  Division.mp40,
  Division.mp50,
  Division.fpo,
];

const List<Division> amateurDivisions = [
  Division.ma1,
  Division.ma2,
  Division.ma3,
  Division.fa1,
  Division.fa2,
  Division.fa3,
  Division.junior,
];
/*
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
}*/
