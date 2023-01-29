import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';

import 'firebase_auth_service.dart';
import 'firebase/utils/fb_constants.dart';

final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();

class BetaAccessService {
  bool _isAdmin = false;
  List<String> _trebuchets = [];
  bool needsReload = false;

  Future<void> loadFeatureAccess() async {
    final String? uid = _authService.getCurrentUserId();
    if (uid == null) {
      needsReload = true;
      return;
    }

    final Map<String, dynamic>? userDoc = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .get()
        .then((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return snapshot.data();
    }).catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[BetaAccessService][loadFeatureAccess] firestore exception',
      );
      return null;
    });

    if (userDoc == null) {
      needsReload = true;
      return;
    }
    try {
      final MyPuttUser user = MyPuttUser.fromJson(userDoc);
      needsReload = false;
      _isAdmin = user.isAdmin ?? false;
      _trebuchets = user.trebuchets ?? [];
    } catch (e) {
      needsReload = true;
      return;
    }
  }

  bool hasFeatureAccess({String? featureName}) {
    if (kDebugMode) {
      return true;
    }
    if (_isAdmin == true) {
      return true;
    } else if (featureName != null) {
      return _trebuchets.contains(featureName);
    }
    return false;
  }
}
