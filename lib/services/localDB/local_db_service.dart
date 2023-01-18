import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/localDB/constants.dart';

class LocalDBService {
  final _sessionsBox = Hive.box(kSessionsBoxKey);

  Future<bool> deleteAllData() async {
    try {
      return _sessionsBox.deleteFromDisk().then((_) => true);
    } catch (e) {
      return false;
    }
  }

  Future<bool> storeCompletedSessions(
    List<PuttingSession> completedSessions,
  ) async {
    try {
      return _sessionsBox
          .put(
            kCompletedSessionsKey,
            List.from(completedSessions.map((session) => session.toJson())),
          )
          .then((_) => true);
    } catch (e) {
      return false;
    }
  }

  Future<List<PuttingSession>?> retrieveCompletedSessions() async {
    return _sessionsBox.get(kCompletedSessionsKey).then((result) {
      print('retrieved completed sessions');
      print(result);
      return [];
    });
  }
}
