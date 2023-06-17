import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:myputt/models/data/putting_preferences/putting_preferences.dart';
import 'package:myputt/protocols/myputt_repository.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/constants/flags.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class PuttingPreferencesRepository extends ChangeNotifier
    implements MyPuttRepository {
  @override
  void initSingletons() {
    _localDBService = locator.get<LocalDBService>();
  }

  late final LocalDBService _localDBService;

  PuttingPreferences? _puttingPreferences;

  PuttingPreferences get puttingPreferences {
    return _puttingPreferences ?? const PuttingPreferences();
  }

  set puttingPreferences(PuttingPreferences? preferences) {
    _puttingPreferences = preferences;
    notifyListeners();
  }

  set puttingConditions(PuttingConditions conditions) {
    _puttingPreferences =
        puttingPreferences.copyWith(puttingConditions: conditions);
    _saveLocalPuttingPreferences();
  }

  set preferredDistance(int distance) {
    _puttingPreferences =
        puttingPreferences.copyWith(preferredDistance: distance);
    _saveLocalPuttingPreferences();
  }

  set preferredSetLength(int setLength) {
    _puttingPreferences =
        puttingPreferences.copyWith(preferredSetLength: setLength);
    _saveLocalPuttingPreferences();
  }
  // int get preferredDistance {
  //   return _preferredDistance ?? kDefaultDistanceFt;
  // }
  //
  // int get preferredSetLength {
  //   return _preferredSetLength ?? kDefaultSetLength;
  // }
  //
  // set currentPuttingConditions(PuttingConditions? conditions) {
  //   _currentPuttingConditions = conditions;
  //   notifyListeners();
  // }
  //
  // set preferredDistance(int distance) {
  //   _preferredDistance = distance;
  //   notifyListeners();
  // }
  //
  // set preferredSetLength(int setLength) {
  //   _preferredSetLength = setLength;
  //   notifyListeners();
  // }

  @override
  void clearData() {
    puttingPreferences = null;
    _localDBService.deletePuttingConditions();
  }

  void fetchLocalPuttingPreferences() {
    puttingPreferences = _localDBService.fetchPuttingPreferences();
  }

  void _saveLocalPuttingPreferences() {
    _localDBService
        .savePuttingPreferences(puttingPreferences)
        .then((bool success) {
      _log('[_saveLocalPuttingPreferences] success: $success');
    });
  }

  void _log(String message) {
    if (Flags.kPuttingPreferencesRepositoryLogs) {
      log('[PuttingPreferencesRepository] $message');
    }
  }
}
