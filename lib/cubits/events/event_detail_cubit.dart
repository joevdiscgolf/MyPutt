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

  Future<void> reload() async {
    await Future.wait([
      reloadEvent(),
      reloadPlayerData(),
    ]);
  }

  Future<MyPuttEvent?> reloadEvent() async {
    final MyPuttEvent? updatedEvent =
        await _eventsRepository.reloadCurrentEvent();

    if (updatedEvent == null) {
      // Failure toast
      return null;
    }

    if (_eventsRepository.currentEventPlayerData != null) {
      emit(
        EventDetailLoaded(
          event: updatedEvent,
          currentPlayerData: _eventsRepository.currentEventPlayerData!,
        ),
      );
    }
    return updatedEvent;
  }

  Future<bool> reloadPlayerData() async {
    final EventPlayerData? updatedPlayerData =
        await _eventsRepository.fetchDBPlayerData();

    if (updatedPlayerData == null) {
      // show error toast
      return false;
    }

    if (_eventsRepository.currentEvent != null) {
      emit(EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: updatedPlayerData,
      ));
      return true;
    } else {
      return false;
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
    _eventsRepository.currentEventPlayerData = playerData;
    emit(
      EventDetailLoaded(
        event: event,
        currentPlayerData: _eventsRepository.currentEventPlayerData!,
      ),
    );
  }

  Future<void> addSet(PuttingSet set) async {
    if (_eventsRepository.currentEventPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      // Show toast
      _toastService.triggerToast('Something went wrong');
      return;
    } else if (_eventsRepository.currentEventPlayerData!.sets.length ==
        _eventsRepository
            .currentEvent!.eventCustomizationData.challengeStructure.length) {
      return;
    }

    _eventsRepository.currentEventPlayerData!.sets.add(set);

    emit(
      EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: _eventsRepository.currentEventPlayerData!,
      ),
    );

    _saveUpdatedPlayerData();
  }

  Future<void> undoSet() async {
    if (_eventsRepository.currentEventPlayerData == null ||
        _eventsRepository.currentEvent == null ||
        state is EventDetailInitial) {
      // show error toast
      return;
    }

    if (_eventsRepository.currentEventPlayerData!.sets.isNotEmpty) {
      _eventsRepository.currentEventPlayerData!.sets.removeLast();

      emit(
        EventDetailLoaded(
          event: _eventsRepository.currentEvent!,
          currentPlayerData: _eventsRepository.currentEventPlayerData!,
        ),
      );

      _saveUpdatedPlayerData();
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    if (_eventsRepository.currentEventPlayerData == null ||
        _eventsRepository.currentEvent == null ||
        state is EventDetailInitial) {
      // show error toast
      return;
    }

    _eventsRepository.currentEventPlayerData!.sets.remove(set);

    emit(
      EventDetailLoaded(
        event: _eventsRepository.currentEvent!,
        currentPlayerData: _eventsRepository.currentEventPlayerData!,
      ),
    );

    _saveUpdatedPlayerData();
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
            ),
          );
        }
      } catch (e) {
        return;
      }
    });
  }

  Future<bool> _saveUpdatedPlayerData() async {
    try {
      return _eventsRepository.saveLocalPlayerSets().then(
        (SavePlayerSetsResponse response) async {
          if (response.eventStatus == EventStatus.complete) {
            // show error toast
            reloadEvent();
            return false;
          } else {
            return true;
          }
        },
      );
    } catch (e) {
      // ignore network errors
      return false;
    }
  }

  Future<void> _connectivityListener(ConnectivityResult result) async {
    final bool wasConnected = _connected;
    _connected = isConnected(result);

    // Connection re-established
    if (!wasConnected && _connected) {
      if (_eventsRepository.currentEvent == null) {
        return;
      }

      final MyPuttEvent? updatedEvent = await reloadEvent();

      if (updatedEvent == null) {
        // show error toast
        return;
      } else if (updatedEvent.status == EventStatus.complete) {
        // show error toast

        // try to revert sets to database copy
        try {
          final EventPlayerData? databasePlayerData =
              await _eventsRepository.fetchDBPlayerData();

          if (databasePlayerData == null) {
            return;
          }

          emit(
            EventDetailLoaded(
              event: updatedEvent,
              currentPlayerData: databasePlayerData,
            ),
          );
        }
        // catch network error
        catch (e) {
          // show error toast
          return;
        }
      } else if (_eventsRepository.currentEventPlayerData != null) {
        final bool saveSuccess = await _saveUpdatedPlayerData();
        // fetch continually.
      }

      // if (_eventsRepository.currentEvent != null &&
      //     _eventsRepository.currentPlayerData != null) {
      //   final SavePlayerSetsResponse response =
      //       await _eventsRepository.saveLocalPlayerSets();
      //
      //   // If the event is complete, lock them out of saving sets.
      //   if (response.eventStatus == EventStatus.complete) {
      //     final GetEventPlayerDataResponse response = await _eventsService
      //         .getEventPlayerData(_eventsRepository.currentEvent!.eventId);
      //
      //     // Successfully loaded player data from backend
      //     // Emit new state with up-to-date
      //     if (response.eventPlayerData != null) {
      //       _eventsRepository.currentPlayerData = response.eventPlayerData;
      //       if (state is EventDetailLoaded) {
      //         _eventsRepository.currentEvent!.status = EventStatus.complete;
      //         emit(
      //           EventDetailLoaded(
      //             event: _eventsRepository.currentEvent!,
      //             currentPlayerData: _eventsRepository.currentPlayerData!,
      //           ),
      //         );
      //       }
      //     }
      //     // Failed to load player data from backend.
      //     else {
      //       // Trigger error
      //     }
      //   } else if (!response.success) {
      //     //  Failed to sync sets to backend
      //   } else {
      //     // synced successfully
      //   }
      // }
    }
  }
}
