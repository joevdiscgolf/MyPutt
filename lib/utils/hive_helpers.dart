import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/services/localDB/constants.dart';

Future<void> initLocalDatabase() async {
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(HiveBoxes.kSessionsBoxKey),
    Hive.openBox(HiveBoxes.kChallengesBoxKey),
    Hive.openBox(HiveBoxes.kUserBoxKey),
    Hive.openBox(HiveBoxes.kPuttingConditionsBoxKey)
  ]);
}
