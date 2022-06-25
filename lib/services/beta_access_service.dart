import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/locator.dart';

import 'auth_service.dart';
import 'firebase/utils/fb_constants.dart';

final AuthService _authService = locator.get<AuthService>();

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
    });
    if (userDoc == null) {
      needsReload = true;
      return;
    }
    needsReload = false;
    _isAdmin = userDoc['isAdmin'] ?? false;
    _trebuchets = userDoc['trebuchets'] ?? [];
  }

  bool hasFeatureAccess({String? featureName}) {
    if (_isAdmin == true) {
      return true;
    } else if (featureName != null) {
      return _trebuchets.contains(featureName);
    }
    return false;
  }
}
