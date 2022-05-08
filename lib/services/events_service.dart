import 'package:cloud_functions/cloud_functions.dart';
import 'package:myputt/data/endpoints/events/event_endpoints.dart';
import 'package:myputt/data/types/events/event_enums.dart';

class EventsService {
  Future<GetEventStandingsResponse> getEventStandings(String eventId,
      {Division? division}) {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getEventStandings');

    final GetEventStandingsRequest request =
        GetEventStandingsRequest(eventId: eventId, division: division);

    return callable(request.toJson())
        .then((HttpsCallableResult<dynamic> response) {
      return GetEventStandingsResponse.fromJson(response.data);
    }).catchError((e, trace) async {
      return GetEventStandingsResponse();
    });
  }
}
