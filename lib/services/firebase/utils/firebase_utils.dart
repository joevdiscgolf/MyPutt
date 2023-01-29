import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/connectivity_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/utils.dart';

Future<DocumentSnapshot<Map<String, dynamic>>?> firestoreFetch(
  String path,
) async {
  try {
    return FirebaseFirestore.instance.doc(path).get().timeout(standardTimeout);
  } catch (e, trace) {
    FirebaseCrashlytics.instance.recordError(
      e,
      trace,
      reason: '[firestore][utils][firestoreFetch] exception',
    );
    return null;
  }
}

Future<QuerySnapshot?> firestoreQuery({
  required String path,
  Object? isEqualTo,
  Object? isNotEqualTo,
  Object? isLessThan,
  Object? isLessThanOrEqualTo,
  Object? isGreaterThan,
  Object? isGreaterThanOrEqualTo,
  Object? arrayContains,
  List<Object?>? arrayContainsAny,
  List<Object?>? whereIn,
  List<Object?>? whereNotIn,
}) async {
  final bool connected =
      isConnected(locator.get<ConnectivityService>().connectivityResult);

  if (!connected) {
    return null;
  }

  try {
    return FirebaseFirestore.instance
        .collection(path)
        .where(
          path,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
        )
        .get()
        .timeout(standardTimeout);
  } catch (e, trace) {
    FirebaseCrashlytics.instance.recordError(
      e,
      trace,
      reason: '[firestore][utils][firestoreQuery] exception',
    );
    return null;
  }
}
