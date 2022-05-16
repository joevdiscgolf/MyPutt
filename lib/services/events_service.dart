import 'package:cloud_functions/cloud_functions.dart';
import 'package:myputt/data/endpoints/events/event_endpoints.dart';
import 'package:myputt/data/types/events/event_enums.dart';

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
}
