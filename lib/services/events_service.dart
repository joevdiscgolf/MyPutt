import 'package:cloud_functions/cloud_functions.dart';
import 'package:myputt/data/endpoints/events/event_endpoints.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';

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
      return ExitEventResponse(success: false);
    });
  }

  Future<SearchEventsResponse> searchEvents(String keyword) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('searchEvents');

    final SearchEventsRequest request = SearchEventsRequest(keyword: keyword);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return SearchEventsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      print(e);
      return SearchEventsResponse(events: []);
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
      return UpdatePlayerSetsResponse(success: false);
    });
  }
}
