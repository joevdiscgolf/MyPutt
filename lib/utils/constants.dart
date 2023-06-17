import 'package:flutter/material.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/utils/colors.dart';

import 'enums.dart';

const int kDefaultDistanceFt = 20;
const int kDefaultSetLength = 10;

const int kTapThresholdMilliseconds = 200;
const double kTopNavBarHeight = 56;

const kMixpanelProductionToken = 'ab0d6ddcbf4e268b5344eac8568449ec';
const kMixpanelDevelopmentToken = '2b158a436ff4f818d5da5c4dc846696a';

const double kIPhone8Height = 667;

const Duration tinyTimeout = Duration(seconds: 3);
const Duration shortTimeout = Duration(seconds: 6);
const Duration standardTimeout = Duration(seconds: 10);

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

abstract class CircleCutoffs {
  static const int c1x = 11;
  static const int c2 = 33;
  static const int none = 0;
}

const Map<Circles, String> circleToNameMap = {
  Circles.circle1: 'Circle 1',
  Circles.circle2: 'Circle 2'
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

const List<int> kDistanceOptions = [10, 15, 20, 25, 30, 40, 50, 60];

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
  for (int i = 0; i < 4; i++)
    MyPuttEvent(
        eventId: 'e08d36dc-5df4-411d-9d26-8e68122044bb',
        code: 123,
        name: 'Summer Sizzler',
        eventCustomizationData: EventCustomizationData(
          challengeStructure: [
            ChallengeStructureItem(distance: 10, setLength: 10)
          ],
          divisions: [Division.mpo, Division.fpo, Division.ma1, Division.fa1],
          verificationRequired: false,
        ),
        eventType: EventType.tournament,
        endTimestamp: 1651109507018,
        startTimestamp: 1650945600000,
        status: EventStatus.active,
        completionTimestamp: 2,
        participantCount: 12,
        creator: MyPuttUserMetadata(
            displayName: 'Joe v',
            uid: 'BnisFzLsy0PnJuXv26BQ86HTVJk2',
            username: 'joey'),
        creatorUid: 'BnisFzLsy0PnJuXv26BQ86HTVJk2',
        admins: [
          MyPuttUserMetadata(displayName: 'Joe v', uid: '', username: 'joey')
        ],
        adminUids: [
          'BnisFzLsy0PnJuXv26BQ86HTVJk2'
        ])
];

const Map<EventType, String> eventTypeToName = {
  EventType.club: 'Club',
  EventType.tournament: 'Tournament'
};

const kDefaultEventImgPath = 'assets/images/discgolf_wallpaper.jpeg';

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

const Map<ChallengeCategory, String> challengeCategoryToName =
    <ChallengeCategory, String>{
  ChallengeCategory.complete: 'completed',
  ChallengeCategory.pending: 'pending',
  ChallengeCategory.active: 'active',
};

const Map<Division, String> divisionToNameMap = {
  Division.mpo: 'mpo',
  Division.mp40: 'mp40',
  Division.mp50: 'mp50',
  Division.ma1: 'ma1',
  Division.ma2: 'ma2',
  Division.ma3: 'ma3',
  Division.ma4: 'ma4',
  Division.ma5: 'ma5',
  Division.fpo: 'fpo',
  Division.fa1: 'fa1',
  Division.fa2: 'fa2',
  Division.fa3: 'fa3',
  Division.junior: 'junior',
  Division.mixed: 'mixed',
};
