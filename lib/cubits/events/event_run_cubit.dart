import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:myputt/models/endpoints/events/event_endpoints.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';

part 'event_run_state.dart';

class EventRunCubit extends Cubit<EventRunState> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final EventsService _eventsService = locator.get<EventsService>();
  bool _newEventCreated = false;

  EventRunCubit() : super(EventRunLoading());

  bool get newEventWasCreated => _newEventCreated;

  Future<void> openEvent(MyPuttEvent event) async {
    _eventsRepository.initializeEventStream(event.eventId);

    _eventsRepository.currentEvent = event;
    emit(EventRunLoading());
    final EventPlayerData? playerData =
        await _databaseService.loadEventPlayerData(event.eventId);
    if (playerData == null) {
      emit(EventRunError());
      return;
    }
    _eventsRepository.currentPlayerData = playerData;
    emit(EventRunActive(event: event));
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

  Future<bool> endEvent(String eventId) async {
    final bool success = await _eventsService.endEvent(eventId);

    if (success) {
      emit(EventRunComplete());
    }
    return success;
  }
}
