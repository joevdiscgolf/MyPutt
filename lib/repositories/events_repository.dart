import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/repositories/repository.dart';
import 'package:myputt/services/events_service.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventsRepository implements Repository {
  @override
  void initializeServices() {
    _eventsService = locator.get<EventsService>();
  }

  late final EventsService _eventsService;

  MyPuttEvent? currentEvent;
  EventPlayerData? currentPlayerData;

  Future<SavePlayerSetsResponse> resyncSets() async {
    if (currentPlayerData == null || currentEvent == null) {
      return const SavePlayerSetsResponse(success: false);
    }
    return _eventsService.savePlayerSets(
      currentEvent!.eventId,
      currentPlayerData!.sets,
    );
  }

  void clearData() {
    currentEvent = null;
    currentPlayerData = null;
  }
}
