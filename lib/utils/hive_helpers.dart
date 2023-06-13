import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/services/localDB/constants.dart';

Future<void> initLocalDatabase() async {
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(kSessionsBoxKey),
    Hive.openBox(kChallengesBoxKey),
    Hive.openBox(kUserBoxKey),
  ]);
}
