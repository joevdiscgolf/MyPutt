import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/utils/event_helpers.dart';
import 'package:myputt/utils/utils.dart';

part 'event_standings_state.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventStandingsCubit extends Cubit<EventStandingsState> {
  EventStandingsCubit() : super(EventStandingsLoading()) {
    Connectivity().checkConnectivity().then((connectivityResult) =>
        _connected = hasConnectivity(connectivityResult));

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) => _connectivityListener(result));
  }

  final DatabaseService _databaseService = locator.get<DatabaseService>();

  Division? _division;
  bool _connected = true;

  bool _firstDocumentSnapshot = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StreamSubscription<QuerySnapshot<Object?>>? _eventStandingsSubscription;

  Future<void> openEvent(MyPuttEvent event) async {
    _initStandingsSubscription(event.eventId);

    final Division initialDivision =
        getInitialDivision(event.eventCustomizationData.divisions);

    _division = initialDivision;
    loadDivisionStandings(event.eventId, initialDivision);
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
    _division = updatedDivision;
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
            playerData.where((data) => data.division == _division).toList();
      }
      emit(EventStandingsLoaded(divisionStandings: playerData));
    });
  }

  void exitEventScreen() {
    _firstDocumentSnapshot = true;
    _eventStandingsSubscription?.cancel();
    _connectivitySubscription?.cancel();
  }

  // Re-initialize subscription when back online.
  void _connectivityListener(ConnectivityResult result) {
    final bool wasConnected = _connected;
    _connected = hasConnectivity(result);

    if (!wasConnected && _connected) {
      _eventStandingsSubscription?.cancel();
      if (locator.get<EventsRepository>().currentEvent != null) {
        _initStandingsSubscription(
          locator.get<EventsRepository>().currentEvent!.eventId,
        );
      }
    }
  }
}
