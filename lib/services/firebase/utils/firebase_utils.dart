import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/services/firebase/utils/types.dart';
import 'package:myputt/services/global_settings.dart';
import 'package:myputt/utils/constants.dart';

Future<DocumentSnapshot<Map<String, dynamic>>?> firestoreFetch(
  String path, {
  Duration timeout = shortTimeout,
}) async {
  try {
    return FirebaseFirestore.instance.doc(path).get().then(
      (snapshot) {
        if (!GlobalSettings.useFirebaseCache && snapshot.metadata.isFromCache) {
          log('[firestore][utils][firestoreFetch] returning null snapshot from cache, path: $path ');
          return null;
        } else {
          return snapshot;
        }
      },
    ).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason: '[firestore][utils][firestoreFetch] exception, path: $path',
        );
        return null;
      },
    ).timeout(timeout);
  } catch (e, trace) {
    FirebaseCrashlytics.instance.recordError(
      e,
      trace,
      reason: '[firestore][utils][firestoreFetch] exception, path: $path',
    );
    return null;
  }
}

Future<QuerySnapshot<Map<String, dynamic>>?> firestoreQuery({
  required String path,
  List<FirestoreQueryInstruction>? firestoreQueries,
  String? orderBy,
  Duration timeout = shortTimeout,
}) async {
  try {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(path);
    Query<Map<String, dynamic>>? query;
    late final Future<QuerySnapshot<Map<String, dynamic>>> fetch;

    if (firestoreQueries?.isNotEmpty == true || orderBy != null) {
      if (firestoreQueries?.isNotEmpty == true) {
        for (FirestoreQueryInstruction firestoreQuery in firestoreQueries!) {
          if (query != null) {
            query = query.where(
              firestoreQuery.field,
              isEqualTo: firestoreQuery.isEqualTo,
              isNotEqualTo: firestoreQuery.isNotEqualTo,
              isLessThan: firestoreQuery.isLessThan,
              isLessThanOrEqualTo: firestoreQuery.isLessThanOrEqualTo,
              isGreaterThan: firestoreQuery.isGreaterThan,
              isGreaterThanOrEqualTo: firestoreQuery.isGreaterThanOrEqualTo,
              arrayContains: firestoreQuery.arrayContains,
              arrayContainsAny: firestoreQuery.arrayContainsAny,
              whereIn: firestoreQuery.whereIn,
              whereNotIn: firestoreQuery.whereNotIn,
            );
          } else {
            query = collectionReference.where(
              firestoreQuery.field,
              isEqualTo: firestoreQuery.isEqualTo,
              isNotEqualTo: firestoreQuery.isNotEqualTo,
              isLessThan: firestoreQuery.isLessThan,
              isLessThanOrEqualTo: firestoreQuery.isLessThanOrEqualTo,
              isGreaterThan: firestoreQuery.isGreaterThan,
              isGreaterThanOrEqualTo: firestoreQuery.isGreaterThanOrEqualTo,
              arrayContains: firestoreQuery.arrayContains,
              arrayContainsAny: firestoreQuery.arrayContainsAny,
              whereIn: firestoreQuery.whereIn,
              whereNotIn: firestoreQuery.whereNotIn,
            );
          }
        }
      }
      if (orderBy != null) {
        if (query != null) {
          query = query.orderBy(orderBy);
        } else {
          query = collectionReference.orderBy(orderBy);
        }
      }
    }

    if (query != null) {
      fetch = query.get();
    } else {
      print('collection reference get');
      fetch = collectionReference.get();
    }

    return fetch.then(
      (querySnapshot) {
        if (!GlobalSettings.useFirebaseCache &&
            querySnapshot.metadata.isFromCache) {
          '[firestore][utils][firestoreQuery] is from cache: ${querySnapshot.metadata.isFromCache}, path: $path';
          return null;
        }
        return querySnapshot;
      },
    ).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason: '[firestore][utils][firestoreQuery] exception, path: $path',
        );
        return null;
      },
    ).timeout(timeout);
  } catch (e, trace) {
    FirebaseCrashlytics.instance.recordError(
      e,
      trace,
      reason: '[firestore][utils][firestoreQuery] exception, path: $path',
    );
    return null;
  }
}
