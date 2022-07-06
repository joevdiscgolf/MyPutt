import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDataWriter {
  Future<bool> updatePlayerSets(
      String uid, String eventId, List<PuttingSet> sets) {
    final challengeRef = firestore
        .doc('$eventsCollection/$eventId/$participantsCollection/$uid');

    final List<Map<String, dynamic>> jsonSets = [];
    for (PuttingSet set in sets) {
      jsonSets.add(set.toJson());
    }
    return challengeRef
        .set({'sets': jsonSets}, SetOptions(merge: true))
        .then((value) => true)
        .catchError((e) {
          log(e);
          return false;
        });
  }
}
