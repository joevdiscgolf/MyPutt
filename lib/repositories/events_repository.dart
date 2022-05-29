import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/events/event_create_params.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventsRepository {
  final DatabaseService _databaseService = locator.get<DatabaseService>();

  MyPuttEvent? currentEvent;
  EventPlayerData? currentPlayerData;
  Stream<List<EventPlayerData>>? playerDataStream;
  StreamController<List<EventPlayerData>>? controller;
  StreamSubscription? documentSubscription;
  EventCreateParams eventCreateParams = EventCreateParams();

  void initializeEventStream(String eventId) {
    documentSubscription?.cancel();
    controller ??= StreamController<List<EventPlayerData>>.broadcast();
    playerDataStream = controller?.stream;
    final CollectionReference reference = firestore
        .collection('$eventsCollection/$eventId/$participantsCollection');
    documentSubscription = reference.snapshots().listen((querySnapshot) {
      List<EventPlayerData> playerData = [];
      for (var snapshot in querySnapshot.docs) {
        if (!snapshot.exists || snapshot.data() == null) {
          continue;
        }
        playerData.add(
            EventPlayerData.fromJson(snapshot.data()! as Map<String, dynamic>));
      }
      controller?.add(playerData);
    });
  }

  Future<bool> resyncSets() async {
    if (currentPlayerData == null || currentEvent == null) {
      return false;
    }
    return _databaseService.updatePlayerSets(
        currentEvent!.eventId, currentPlayerData!.sets);
  }
}
