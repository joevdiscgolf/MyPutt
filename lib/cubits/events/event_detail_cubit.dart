import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:myputt/services/toast_service.dart';
import 'package:myputt/utils/utils.dart';

part 'event_detail_state.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit() : super(EventDetailInitial()) {
    Connectivity().checkConnectivity().then(
        (connectivityResult) => _connected = isConnected(connectivityResult));

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) => _connectivityListener(result));
  }

  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final EventsService _eventsService = locator.get<EventsService>();
  final ToastService _toastService = locator.get<ToastService>();

  bool newEventCreated = false;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StreamSubscription<DocumentSnapshot<Object?>>? _eventStreamSubscription;

  bool _firstDocumentEvent = true;
  bool _connected = true;

  void createEventPressed() {
    newEventCreated = false;
  }

  void exitEventScreen() {
    _firstDocumentEvent = false;
    _eventStreamSubscription?.cancel();
    _connectivitySubscription?.cancel();
    emit(EventDetailInitial());
  }

  Future<void> reloadEventDetails(String eventId) async {
    final MyPuttEvent? updatedEvent = await _eventsService
        .getEvent(eventId)
        .then((response) => response.event);

    if (updatedEvent == null) {
      // Failure toast
      return;
    }

    if (state is EventDetailLoaded) {
      final EventDetailLoaded loadedState = state as EventDetailLoaded;
      emit(
        EventDetailLoaded(
          event: updatedEvent,
          currentPlayerData: loadedState.currentPlayerData,
          connected: _connected,
        ),
      );
    }
  }

  Future<void> openEvent(MyPuttEvent event) async {
    _firstDocumentEvent = true;
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
        connected: _connected,
      ),
    );
  }

  Future<void> addSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      // Show toast
      _toastService.triggerToast('Something went wrong');
      return;
    } else if (_eventsRepository.currentPlayerData!.sets.length ==
        _eventsRepository
            .currentEvent!.eventCustomizationData.challengeStructure.length) {
      return;
    }

    final EventPlayerData previousPlayerData =
        _eventsRepository.currentPlayerData!;

    _eventsRepository.currentPlayerData!.sets.add(set);

    _saveUpdatedPlayerData(previousPlayerData: previousPlayerData);
  }

  Future<void> undoSet() async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventDetailError());
      return;
    }

    if (_eventsRepository.currentPlayerData!.sets.isNotEmpty) {
      final EventPlayerData previousPlayerData =
          _eventsRepository.currentPlayerData!;
      _eventsRepository.currentPlayerData!.sets.removeLast();
      _saveUpdatedPlayerData(previousPlayerData: previousPlayerData);
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventDetailError());
      return;
    }

    final EventPlayerData previousPlayerData =
        _eventsRepository.currentPlayerData!;
    _eventsRepository.currentPlayerData!.sets.remove(set);
    _saveUpdatedPlayerData(previousPlayerData: previousPlayerData);
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
      newEventCreated = true;
    }
    return response.eventId != null;
  }

  void _initEventSubscription(String eventId) {
    DocumentReference eventRef = firestore.doc('$eventsCollection/$eventId');
    _eventStreamSubscription =
        eventRef.snapshots().listen((DocumentSnapshot snapshot) {
      if (_firstDocumentEvent) {
        _firstDocumentEvent = false;
        return;
      }
      if (snapshot.data() == null) {
        return;
      }
      try {
        final MyPuttEvent updatedEvent =
            MyPuttEvent.fromJson(snapshot.data() as Map<String, dynamic>);

        if (state is EventDetailLoaded) {
          final EventDetailLoaded activeState = state as EventDetailLoaded;
          _eventsRepository.currentEvent = updatedEvent;
          emit(
            EventDetailLoaded(
              event: updatedEvent,
              currentPlayerData: activeState.currentPlayerData,
              connected: _connected,
            ),
          );
        }
      } catch (e) {
        return;
      }
    });
  }

  void _saveUpdatedPlayerData({required EventPlayerData previousPlayerData}) {
    emit(
      EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: _eventsRepository.currentPlayerData!,
        connected: _connected,
      ),
    );
    try {
      _eventsRepository.resyncSets().then((SavePlayerSetsResponse response) {
        if (response.eventStatus == EventStatus.complete) {
          // Revert changes
          emit(
            EventDetailLoaded(
              event: _eventsRepository.currentEvent!,
              currentPlayerData: previousPlayerData,
              connected: _connected,
            ),
          );
        }
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _connectivityListener(ConnectivityResult result) async {
    final bool wasConnected = _connected;
    _connected = isConnected(result);

    // if (state is EventDetailLoaded) {
    //   emit(EventDetailLoaded(
    //       event: state.event,
    //       currentPlayerData: state.currentPlayerData,
    //       connected: _connected));
    // }

    // Resync sets when coming back online.
    if (!wasConnected && _connected) {
      try {
        if (_eventsRepository.currentEvent != null &&
            _eventsRepository.currentPlayerData != null) {
          final SavePlayerSetsResponse response =
              await _eventsRepository.resyncSets();

          // If the event is complete, lock them out of saving sets.
          if (response.eventStatus == EventStatus.complete) {
            final GetEventPlayerDataResponse response = await _eventsService
                .getEventPlayerData(_eventsRepository.currentEvent!.eventId);

            // Successfully loaded player data from backend
            // Emit new state with up-to-date
            if (response.eventPlayerData != null) {
              _eventsRepository.currentPlayerData = response.eventPlayerData;
              if (state is EventDetailLoaded) {
                _eventsRepository.currentEvent!.status = EventStatus.complete;
                emit(
                  EventDetailLoaded(
                    event: _eventsRepository.currentEvent!,
                    currentPlayerData: _eventsRepository.currentPlayerData!,
                    connected: _connected,
                  ),
                );
              }
            }
            // Failed to load player data from backend.
            else {
              // Trigger error
            }
          } else if (!response.success) {
            //  Failed to sync sets to backend
          } else {
            // synced successfully
          }
        }
      } catch (e) {
        return;
      }
    }
  }
}
