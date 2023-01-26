import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<String?> getMinimumAppVersion() async {
  try {
    DocumentSnapshot<dynamic> snapshot = await FirebaseFirestore.instance
        .doc('$appInfoCollection/$minimumVersionDoc')
        .get()
        .timeout(shortTimeout);
    if (snapshot.exists && snapshot.data()['minimumVersion'] != null) {
      return snapshot.data()['minimumVersion'];
    } else {
      return null;
    }
  } catch (e, trace) {
    log(e.toString());
    log(trace.toString());
    FirebaseCrashlytics.instance.recordError(
      e,
      trace,
      reason: '[app_info_data_loader][getMinimumAppVersion] firestore timeout',
    );
    return null;
  }
}
