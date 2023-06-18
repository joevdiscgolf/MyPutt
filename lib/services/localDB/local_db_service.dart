import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/putting_preferences/putting_preferences.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/localDB/constants.dart';

class LocalDBService {
  final Box<dynamic> _sessionsBox = Hive.box(HiveBoxes.kSessionsBoxKey);
  final Box<dynamic> _challengesBox = Hive.box(HiveBoxes.kChallengesBoxKey);
  final Box<dynamic> _userBox = Hive.box(HiveBoxes.kUserBoxKey);
  final Box<dynamic> _puttingConditionsBox =
      Hive.box(HiveBoxes.kPuttingConditionsBoxKey);

  Future<bool> storeCompletedSessions(
    List<PuttingSession> completedSessions,
  ) async {
    try {
      return _sessionsBox
          .put(
            HiveKeys.kCompletedSessionsKey,
            completedSessions.map((session) => session.toJson()).toList(),
          )
          .then((_) => true);
    } catch (e, trace) {
      log('[LocalDBService][storeCompletedSessions] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  List<PuttingSession>? retrieveCompletedSessions() {
    try {
      final Iterable<dynamic>? results = _sessionsBox
          .get(HiveKeys.kCompletedSessionsKey)
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
    } catch (e, trace) {
      log('[LocalDBService][retrieveCompletedSessions] ${e.toString()}');
      log(trace.toString());
      return null;
    }
  }

  Future<bool> storeCurrentSession(PuttingSession? currentSession) async {
    try {
      if (currentSession != null) {
        return _sessionsBox
            .put(HiveKeys.kCurrentSessionKey, currentSession.toJson())
            .then((_) => true);
      } else {
        return _sessionsBox
            .delete(HiveKeys.kCurrentSessionKey)
            .then((_) => true);
      }
    } catch (e, trace) {
      log('[LocalDBService][storeCurrentSession] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  PuttingSession? retrieveCurrentSession() {
    try {
      final dynamic hashMap = _sessionsBox.get(HiveKeys.kCurrentSessionKey);
      if (hashMap == null) {
        return null;
      }
      return PuttingSession.fromJson(Map<String, dynamic>.from(hashMap));
    } catch (e, trace) {
      log('[LocalDBService][retrieveCurrentSession] ${e.toString()}');
      log(trace.toString());
      return null;
    }
  }

  Future<bool> deleteSessionsData() async {
    try {
      return _sessionsBox.deleteAll(_sessionsBox.keys).then((_) async {
        return true;
      });
    } catch (e, trace) {
      log('[LocalDBService][deleteSessionsData] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  List<PuttingChallenge>? retrievePuttingChallenges() {
    try {
      final Iterable<dynamic>? results = _challengesBox
          .get(HiveKeys.kChallengesKey)
          ?.map((hashMap) =>
              PuttingChallenge.fromJson(Map<String, dynamic>.from(hashMap)));

      if (results == null) {
        return null;
      }

      final List<PuttingChallenge> challenges = [];

      for (var result in results) {
        if (result is PuttingChallenge) {
          challenges.add(result);
        }
      }

      return challenges;
    } catch (e, trace) {
      log('[LocalDBService][retrievePuttingChallenges] ${e.toString()}');
      log(trace.toString());
      return null;
    }
  }

  Future<bool> storeChallenges(List<PuttingChallenge> challenges) async {
    try {
      return _challengesBox
          .put(
            HiveKeys.kChallengesKey,
            challenges.map((challenge) => challenge.toJson()).toList(),
          )
          .then((_) => true);
    } catch (e, trace) {
      log('[LocalDBService][storePuttingChallenges] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  Future<bool> deleteChallengesData() async {
    try {
      return _challengesBox.deleteAll(_challengesBox.keys).then((_) async {
        return true;
      });
    } catch (e, trace) {
      log('[LocalDBService][deleteChallengesData] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  MyPuttUser? fetchCurrentUser() {
    try {
      final dynamic userHashmap = _userBox.get(HiveKeys.kCurrentUserKey);

      if (userHashmap == null) {
        return null;
      }

      return MyPuttUser.fromJson(Map<String, dynamic>.from(userHashmap));
    } catch (e, trace) {
      log('[LocalDBService][fetchCurrentUser] ${e.toString()}');
      log(trace.toString());
      return null;
    }
  }

  Future<bool> saveCurrentUser(MyPuttUser currentUser) async {
    try {
      return _userBox
          .put(HiveKeys.kCurrentUserKey, currentUser.toJson())
          .then((_) => true);
    } catch (e, trace) {
      log('[LocalDBService][saveCurrentUser] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  Future<bool> savePuttingPreferences(PuttingPreferences preferences) async {
    try {
      return _puttingConditionsBox
          .put(HiveKeys.kSavedPuttingConditionsKey, preferences.toJson())
          .then((_) => true);
    } catch (e, trace) {
      log('[LocalDBService][savePuttingPreferences] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }

  PuttingPreferences? fetchPuttingPreferences() {
    try {
      final dynamic puttingConditionsHashMap =
          _puttingConditionsBox.get(HiveKeys.kSavedPuttingConditionsKey);

      if (puttingConditionsHashMap == null) {
        return null;
      }

      return PuttingPreferences.fromJson(
          Map<String, dynamic>.from(puttingConditionsHashMap));
    } catch (e, trace) {
      log('[LocalDBService][fetchPuttingPreferences] ${e.toString()}');
      log(trace.toString());
      return null;
    }
  }

  Future<bool> deletePuttingConditions() async {
    try {
      return _puttingConditionsBox
          .deleteAll(_puttingConditionsBox.keys)
          .then((_) async {
        return true;
      });
    } catch (e, trace) {
      log('[LocalDBService][fetchPuttingPreferences] ${e.toString()}');
      log(trace.toString());
      return false;
    }
  }
}
