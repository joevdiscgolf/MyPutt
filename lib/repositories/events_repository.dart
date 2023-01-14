import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/services/events_service.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventsRepository {
  MyPuttEvent? currentEvent;
  EventPlayerData? currentEventPlayerData;

  Future<MyPuttEvent?> reloadCurrentEvent() async {
    if (currentEvent == null) {
      return null;
    }
    return locator
        .get<EventsService>()
        .getEvent(currentEvent!.eventId)
        .then((response) {
      if (response.event != null) {
        currentEvent = response.event;
      }
      return response.event;
    });
  }

  Future<SavePlayerSetsResponse> saveLocalPlayerSets() async {
    if (currentEventPlayerData == null || currentEvent == null) {
      return SavePlayerSetsResponse(success: false);
    }
    return locator
        .get<EventsService>()
        .savePlayerSets(currentEvent!.eventId, currentEventPlayerData!.sets);
  }

  Future<EventPlayerData?> fetchDBPlayerData() async {
    if (currentEvent == null) {
      return null;
    }
    return locator
        .get<EventsService>()
        .getEventPlayerData(currentEvent!.eventId)
        .then(
      (response) {
        if (response.eventPlayerData != null) {
          currentEventPlayerData = response.eventPlayerData;
        }
        return response.eventPlayerData;
      },
    );
  }
}
