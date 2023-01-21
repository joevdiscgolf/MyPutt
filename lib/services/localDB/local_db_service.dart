import 'dart:developer';

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
            completedSessions.map((session) => session.toJson()).toList(),
          )
          .then((_) => true);
    } catch (e) {
      return false;
    }
  }

  List<PuttingSession>? retrieveCompletedSessions() {
    try {
      final Iterable<dynamic>? results = _sessionsBox
          .get(kCompletedSessionsKey)
          ?.map((hashMap) =>
              PuttingSession.fromJson(Map<String, dynamic>.from(hashMap)));

      if (results == null) {
        return null;
      }

      final List<PuttingSession> puttingSessions = [];

      for (var result in results) {
        if (result is PuttingSession) {
          puttingSessions.add(result);
        }
      }

      return puttingSessions;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
