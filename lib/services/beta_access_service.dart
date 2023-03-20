import 'package:flutter/foundation.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/utils/firebase_utils.dart';

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

    final Map<String, dynamic>? userDoc = await firestoreFetch(
            '$usersCollection/$uid',
            timeoutDuration: const Duration(seconds: 3))
        .then((snapshot) {
      if (snapshot == null || snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return snapshot.data();
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
