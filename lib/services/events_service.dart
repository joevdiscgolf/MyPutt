import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/firebase_auth_service.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventsService {
  Future<GetEventResponse> getEvent(String eventId) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getEvent');

    final GetEventRequest request = GetEventRequest(eventId: eventId);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return GetEventResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][getEvent] exception',
      );
      return GetEventResponse(inEvent: false);
    });
  }

  Future<JoinEventResponse> joinEventWithCode(int code, Division division) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('joinEventWithCode');

    final JoinEventWithCodeRequest request =
        JoinEventWithCodeRequest(code: code, division: division);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return JoinEventResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][joinEventWithCode] exception',
      );
      return JoinEventResponse(success: false);
    });
  }

  Future<JoinEventResponse> joinEvent(String eventId, Division division) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('joinEvent');

    final JoinEventRequest request =
        JoinEventRequest(eventId: eventId, division: division);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return JoinEventResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][joinEvent] exception',
      );
      return JoinEventResponse(success: false);
    });
  }

  Future<ExitEventResponse> exitEvent(String eventId) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('exitEvent');

    final ExitEventRequest request = ExitEventRequest(eventId: eventId);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return ExitEventResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][exitEvent] exception',
      );
      return ExitEventResponse(success: false);
    });
  }

  Future<GetEventsResponse> searchEvents(String keyword) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('searchEvents');

    final SearchEventsRequest request = SearchEventsRequest(keyword: keyword);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return GetEventsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][searchEvents] exception',
      );
      throw e;
    });
  }

  Future<GetEventsResponse> getMyEvents() {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getMyEvents');

    return callable().then((HttpsCallableResult<dynamic> response) {
      return GetEventsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][getMyEvents] exception',
      );
      throw e;
    });
  }

  Future<SavePlayerSetsResponse> savePlayerSets(
    String eventId,
    List<PuttingSet> sets, {
    bool lockedIn = false,
  }) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('savePlayerSets');

    final SavePlayerSetsRequest request =
        SavePlayerSetsRequest(eventId: eventId, sets: sets, lockedIn: lockedIn);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return SavePlayerSetsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][savePlayerSets] exception',
      );
      throw e;
    });
  }

  Future<GetEventPlayerDataResponse> getEventPlayerData(String eventId) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getPlayerData');

    final GetEventPlayerDataRequest request =
        GetEventPlayerDataRequest(eventId: eventId);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return GetEventPlayerDataResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][getEventPlayerData] exception',
      );
      throw e;
    });
  }

  Future<CreateEventResponse> createEvent(CreateEventRequest request) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('createEvent');

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return CreateEventResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][createEvent] exception',
      );
      return CreateEventResponse();
    });
  }

  Future<bool> endEvent(String eventId) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('endEvent');

    final EndEventRequest request = EndEventRequest(eventId: eventId);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return EndEventResponse.fromJson(response.data).success;
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][createEvent] exception',
      );
      return false;
    });
  }

  Future<bool> isInEvent(String eventId) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return false;
    }
    return firestore.doc('$usersCollection/$uid').get().then((snapshot) {
      if (snapshot.data() == null) {
        return false;
      }
      try {
        final MyPuttUser user =
            MyPuttUser.fromJson(snapshot.data() as Map<String, dynamic>);
        return user.eventIds?.contains(eventId) == true;
      } catch (e) {
        return false;
      }
    }).catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][isInEvent] exception',
      );
      return false;
    });
  }
}
