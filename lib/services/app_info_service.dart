import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/endpoints/app_info/app_info_endpoints.dart';

class AppInfoService {
  Future<String?> getMinimumAppVersion() {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getMinimumAppVersion');
    return callable().then((HttpsCallableResult<dynamic> response) {
      print(response.data);
      return GetMinimumVersionResponse.fromJson(response.data).minimumVersion;
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AppInfoService][getMinimumAppVersion] exception',
      );
      throw e;
    });
  }
}
