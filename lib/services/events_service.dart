import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

class EventsService {
  Future<GetEventResponse> getEvent(String eventId, {Division? division}) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getEvent');

    final GetEventRequest request =
        GetEventRequest(eventId: eventId, division: division);

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
      return GetEventsResponse(events: []);
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
      return GetEventsResponse(events: []);
    });
  }

  Future<UpdatePlayerSetsResponse> updatePlayerSets(
      String eventId, List<PuttingSet> sets,
      {bool lockedIn = false}) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('searchEvents');

    final UpdatePlayerSetsRequest request = UpdatePlayerSetsRequest(
        eventId: eventId, sets: sets, lockedIn: lockedIn);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return UpdatePlayerSetsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[EventsService][updatePlayerSets] exception',
      );
      return UpdatePlayerSetsResponse(success: false);
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
}
