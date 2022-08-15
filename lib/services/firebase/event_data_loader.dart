import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDataLoader {
  Future<EventPlayerData?> loadEventPlayerData(String uid, String eventId) {
    final challengeRef = firestore
        .doc('$eventsCollection/$eventId/$participantsCollection/$uid');
    return challengeRef.get().then((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return EventPlayerData.fromJson(snapshot.data()!);
    }).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[EventDataLoader][loadEventPlayerData] firestore read exception',
        );
        return null;
      },
    );
  }
}
