import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/localDB/constants.dart';

class LocalDBService {
  final Box<dynamic> _sessionsBox = Hive.box(kSessionsBoxKey);

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

  Future<bool> storeCurrentSession(PuttingSession? currentSession) async {
    try {
      if (currentSession != null) {
        return _sessionsBox
            .put(kCurrentSessionKey, currentSession.toJson())
            .then((_) => true);
      } else {
        return _sessionsBox.delete(kCurrentSessionKey).then((_) => true);
      }
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      return false;
    }
  }

  PuttingSession? retrieveCurrentSession() {
    try {
      final dynamic hashMap = _sessionsBox.get(kCurrentSessionKey);
      if (hashMap == null) {
        return null;
      }
      return PuttingSession.fromJson(Map<String, dynamic>.from(hashMap));
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCompletedSessions() async {
    try {
      return _sessionsBox.deleteAll(_sessionsBox.keys).then((_) async {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }
}
