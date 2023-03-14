import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBAppInfoDataLoader {
  static final FBAppInfoDataLoader instance = FBAppInfoDataLoader._internal();

  factory FBAppInfoDataLoader() {
    return instance;
  }

  FBAppInfoDataLoader._internal();

  Future<String?> getMinimumAppVersion() async {
    return FirebaseFirestore.instance
        .doc('$appInfoCollection/$minimumVersionDoc')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.metadata.isFromCache) {
        return null;
      }
      if (snapshot.exists && snapshot.data()?['minimumVersion'] != null) {
        return snapshot.data()!['minimumVersion'] as String;
      } else {
        return null;
      }
    }).catchError((e, trace) {
      print('exception here joe');
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AppInfoDataLoader][getMinimumAppVersion] Firestore timeout',
      );
      return null;
    });
  }
}
