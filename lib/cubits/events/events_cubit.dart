import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _eventsRepository = locator.get<EventsRepository>();
  EventsCubit() : super(EventsInitial());

  void openEvent(MyPuttEvent event) {
    emit(ActiveEventState(event: event));
  }

  void updateSets(List<PuttingSet> sets) {
    if (_eventsRepository.currentEvent == null) {
      emit(EventErrorState());
      return;
    }
  }
}
