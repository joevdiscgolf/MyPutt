import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/utils/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDataLoader {
  Future<EventPlayerData?> loadEventPlayerData(String uid, String eventId) {
    final ref = firestore
        .doc('$eventsCollection/$eventId/$participantsCollection/$uid');
    return ref.get().then((snapshot) {
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

  Future<List<EventPlayerData>> getDivisionStandings(
    String eventId,
    Division division,
  ) async {
    return firestore
        .collection('$eventsCollection/$eventId/$participantsCollection')
        .where('division', isEqualTo: divisionToNameMap[division]!)
        .get()
        .then(
      (QuerySnapshot snapshot) {
        final List<EventPlayerData> playerData = List.from(
          snapshot.docs.map<EventPlayerData?>(
            (playerData) {
              if (playerData.data() == null) {
                return null;
              }
              return EventPlayerData.fromJson(
                playerData.data()! as Map<String, dynamic>,
              );
            },
          ).whereType<EventPlayerData>(),
        );
        return playerData;
      },
    ).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[EventDataLoader][getEventStandings] firestore read exception',
        );
        throw e;
      },
    );
  }

  Future<List<EventPlayerData>> getEventStandings(String eventId) async {
    final CollectionReference ref = firestore
        .collection('$eventsCollection/$eventId/$participantsCollection');

    return ref.get().then(
      (QuerySnapshot snapshot) {
        final List<EventPlayerData> playerData = List.from(
          snapshot.docs.map<EventPlayerData?>(
            (playerData) {
              if (playerData.data() == null) {
                return null;
              }
              return EventPlayerData.fromJson(
                playerData.data()! as Map<String, dynamic>,
              );
            },
          ).whereType<EventPlayerData>(),
        );
        return playerData;
      },
    ).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[EventDataLoader][getEventStandings] firestore read exception',
        );
        throw e;
      },
    );
  }
}
