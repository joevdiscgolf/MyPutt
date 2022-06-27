import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<String?> getMinimumAppVersion() async {
  try {
    DocumentSnapshot<dynamic> snapshot = await FirebaseFirestore.instance
        .doc('$appInfoCollection/$minimumVersionDoc')
        .get()
        .timeout(timeoutDuration)
        .catchError((e) {
      log(e);
    });
    if (snapshot.exists && snapshot.data()['minimumVersion'] != null) {
      return snapshot.data()['minimumVersion'];
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
