import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

part 'event_standings_state.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventStandingsCubit extends Cubit<EventStandingsState> {
  EventStandingsCubit() : super(EventStandingsLoading());

  final DatabaseService _databaseService = locator.get<DatabaseService>();

  Division? division;

  bool _firstDocumentSnapshot = true;
  StreamSubscription<QuerySnapshot<Object?>>? _eventStandingsSubscription;

  Future<void> openEvent(String eventId, Division initialDivision) async {
    _initStandingsSubscription(eventId);
    loadDivisionStandings(eventId, initialDivision);
  }

  Future<void> loadDivisionStandings(String eventId, Division division) async {
    emit(EventStandingsLoading());
    try {
      final List<EventPlayerData> allStandings =
          await _databaseService.loadDivisionStandings(eventId, division);
      emit(EventStandingsLoaded(divisionStandings: allStandings));
    } catch (e) {
      emit(EventStandingsError());
    }
  }

  void selectDivision(String eventId, Division updatedDivision) {
    division = updatedDivision;
    emit(EventStandingsLoading());
    loadDivisionStandings(eventId, updatedDivision);
  }

  void _initStandingsSubscription(String eventId) {
    _firstDocumentSnapshot = true;
    final CollectionReference reference = firestore
        .collection('$eventsCollection/$eventId/$participantsCollection');
    _eventStandingsSubscription = reference.snapshots().listen((querySnapshot) {
      if (_firstDocumentSnapshot) {
        _firstDocumentSnapshot = false;
        return;
      }
      List<EventPlayerData> playerData = [];
      for (var snapshot in querySnapshot.docs) {
        if (!snapshot.exists || snapshot.data() == null) {
          continue;
        }
        playerData.add(
          EventPlayerData.fromJson(snapshot.data()! as Map<String, dynamic>),
        );
        playerData =
            playerData.where((data) => data.division == division).toList();
      }
      emit(EventStandingsLoaded(divisionStandings: playerData));
    });
  }

  void cancelStandingsSubscription() {
    _eventStandingsSubscription?.cancel();
    _eventStandingsSubscription = null;
    _firstDocumentSnapshot = true;
  }
}
