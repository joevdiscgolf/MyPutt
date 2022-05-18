import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDataWriter {
  Future<bool> updatePlayerSets(
      String uid, String eventId, EventPlayerData eventPlayerData) {
    final challengeRef =
        firestore.doc('$eventsCollection/$eventId/$challengesCollection/$uid');
    return challengeRef
        .set(eventPlayerData.toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }
}
