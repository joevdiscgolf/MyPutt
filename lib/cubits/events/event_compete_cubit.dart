import 'package:bloc/bloc.dart';
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

part 'event_compete_state.dart';

class EventCompeteCubit extends Cubit<EventCompeteState> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final EventsService _eventsService = locator.get<EventsService>();
  bool _newEventCreated = false;

  EventCompeteCubit() : super(EventCompeteInitial());

  bool get newEventWasCreated => _newEventCreated;

  Future<void> openEvent(MyPuttEvent event) async {
    _eventsRepository.initializeEventStream(event.eventId);

    _eventsRepository.currentEvent = event;
    emit(EventCompeteLoading());
    final EventPlayerData? playerData =
        await _databaseService.loadEventPlayerData(event.eventId);
    if (playerData == null) {
      emit(EventCompeteError());
      return;
    }
    _eventsRepository.currentPlayerData = playerData;
    emit(EventCompeteActive(
        event: event, eventPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<void> addSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventCompeteError());
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
      emit(EventCompeteError());
      return;
    }
    emit(EventCompeteActive(
      event: _eventsRepository.currentEvent!,
      eventPlayerData: _eventsRepository.currentPlayerData!,
    ));
  }

  Future<void> undoSet() async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventCompeteError());
      return;
    }

    _eventsRepository.currentPlayerData!.sets.removeLast();
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventCompeteError());
      return;
    }
    emit(EventCompeteActive(
        event: _eventsRepository.currentEvent!,
        eventPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<void> deleteSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventCompeteError());
      return;
    }

    _eventsRepository.currentPlayerData!.sets.remove(set);
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventCompeteError());
      return;
    }
    emit(EventCompeteActive(
        event: _eventsRepository.currentEvent!,
        eventPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<bool> createEventRequest({
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
}
