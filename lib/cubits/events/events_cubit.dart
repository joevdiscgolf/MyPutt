import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/services/database_service.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();

  EventsCubit() : super(EventsInitial());

  Future<void> openEvent(MyPuttEvent event) async {
    _eventsRepository.initializeEventStream(event.id);

    _eventsRepository.currentEvent = event;
    emit(EventsLoading());
    final EventPlayerData? playerData =
        await _databaseService.loadEventPlayerData(event.id);
    if (playerData == null) {
      emit(EventErrorState());
      return;
    }
    _eventsRepository.currentPlayerData = playerData;
    emit(ActiveEventState(
        event: event, eventPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<void> addSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventErrorState());
      return;
    }
    if (_eventsRepository.currentPlayerData!.sets.length ==
        _eventsRepository.currentEvent!.challengeStructure.length) {
      return;
    }

    _eventsRepository.currentPlayerData!.sets.add(set);
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventErrorState());
      return;
    }
    emit(ActiveEventState(
        event: _eventsRepository.currentEvent!,
        eventPlayerData: _eventsRepository.currentPlayerData!));
  }

  Future<void> deleteSet(PuttingSet set) async {
    if (_eventsRepository.currentPlayerData == null ||
        _eventsRepository.currentEvent == null) {
      emit(EventErrorState());
      return;
    }

    _eventsRepository.currentPlayerData!.sets.remove(set);
    final bool success = await _eventsRepository.resyncSets();
    if (!success) {
      emit(EventErrorState());
      return;
    }
    emit(ActiveEventState(
        event: _eventsRepository.currentEvent!,
        eventPlayerData: _eventsRepository.currentPlayerData!));
  }
}
