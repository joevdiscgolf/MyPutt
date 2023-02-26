import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/services/localDB/constants.dart';

Future<void> initLocalDatabase() async {
  await Hive.initFlutter();
  await Hive.openBox(kSessionsBoxKey);
}
