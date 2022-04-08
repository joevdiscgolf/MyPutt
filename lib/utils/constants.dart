import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

List<ConnectivityResult> validConnectivityResults = [
  ConnectivityResult.wifi,
  ConnectivityResult.mobile
];

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
      id: 'id',
      code: 123,
      name: 'Summer Sizzler',
      challengeStructure: [],
      divisions: [Division.mpo],
      eventType: EventType.tournament,
      endTimestamp: 0,
      status: EventStatus.active,
      creationTimestamp: 1,
      completionTimestamp: 2)
];
