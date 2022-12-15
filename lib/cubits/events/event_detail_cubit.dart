import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

part 'event_detail_state.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final EventsService _eventsService = locator.get<EventsService>();
  bool _newEventCreated = false;
  StreamSubscription<DocumentSnapshot<Object?>>? _eventStreamSubscription;

  EventDetailCubit() : super(EventDetailInitial());

  bool get newEventWasCreated => _newEventCreated;

  Future<void> openEvent(MyPuttEvent event) async {
    _initEventSubscription(event.eventId);
    _eventsRepository.currentEvent = event;
    emit(EventDetailLoading());
    final EventPlayerData? playerData =
        await _databaseService.loadEventPlayerData(event.eventId);
    if (playerData == null) {
      emit(EventDetailError());
      return;
    }
    _eventsRepository.currentPlayerData = playerData;
    emit(
      EventDetailLoaded(
        event: event,
        currentPlayerData: _eventsRepository.currentPlayerData!,
      ),
    );
  }

  void exitEventScreen() {
    _eventStreamSubscription?.cancel();
    _eventStreamSubscription = null;
    emit(EventDetailInitial());
  }

  Future<void> addSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventDetailError());
      return;
    }
    if (_eventsRepository.currentPlayerData!.sets.length ==
        _eventsRepository
            .currentEvent!.eventCustomizationData.challengeStructure.length) {
      return;
    }

    _eventsRepository.currentPlayerData!.sets.add(set);
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventDetailError());
      return;
    }
    emit(EventDetailLoaded(
      event: _eventsRepository.currentEvent!,
      currentPlayerData: _eventsRepository.currentPlayerData!,
    ));
  }

  Future<void> undoSet() async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventDetailError());
      return;
    }

    _eventsRepository.currentPlayerData!.sets.removeLast();
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventDetailError());
      return;
    }
    emit(EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<void> deleteSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventDetailError());
      return;
    }

    _eventsRepository.currentPlayerData!.sets.remove(set);
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventDetailError());
      return;
    }
    emit(
      EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: _eventsRepository.currentPlayerData!,
      ),
    );
  }

  Future<bool> createNewEvent({
    required String eventName,
    String? eventDescription,
    required bool verificationSignature,
    required List<Division> divisions,
    required DateTime startDate,
    TimeOfDay? startTime,
    required DateTime endDate,
    TimeOfDay? endTime,
    required List<ChallengeStructureItem> challengeStructure,
  }) async {
    if (startTime != null) {
      startDate.add(Duration(hours: startTime.hour, minutes: startTime.minute));
    }
    if (endTime != null) {
      endDate.add(Duration(hours: endTime.hour, minutes: endTime.minute));
    }
    final CreateEventResponse response = await _eventsService.createEvent(
      CreateEventRequest(
        eventCreateParams: EventCreateParams(
          name: eventName,
          description: eventDescription,
          verificationRequired: verificationSignature,
          divisions: divisions,
          startDate: startDate.toIso8601String(),
          endDate: endDate.toIso8601String(),
          challengeStructure: challengeStructure,
        ),
      ),
    );
    if (response.eventId != null) {
      _newEventCreated = true;
    }
    return response.eventId != null;
  }

  void createEventPressed() {
    _newEventCreated = false;
  }

  void _initEventSubscription(String eventId) {
    DocumentReference eventRef = firestore.doc('$eventsCollection/$eventId');
    _eventStreamSubscription =
        eventRef.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.data() == null) {
        return;
      }
      try {
        final MyPuttEvent updatedEvent =
            MyPuttEvent.fromJson(snapshot.data() as Map<String, dynamic>);
        if (state is EventDetailLoaded) {
          final EventDetailLoaded activeState = state as EventDetailLoaded;
          emit(
            EventDetailLoaded(
              event: updatedEvent,
              currentPlayerData: activeState.currentPlayerData,
            ),
          );
        }
      } catch (e) {
        return;
      }
    });
  }
}
