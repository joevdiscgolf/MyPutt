import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/cubits/events/event_standings_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/models/data/events/ordered_standing.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/utils/calculators.dart';

List<OrderedStanding> getOrderedStandings(List<EventPlayerData> standings) {
  List<OrderedStanding> orderedStandings = standings
      .map((eventPlayerData) => OrderedStanding(
            eventPlayerData: eventPlayerData,
            puttsMade: totalMadeFromSets(eventPlayerData.sets),
            position: '',
          ))
      .toList();

  orderedStandings.sort((s1, s2) => s2.puttsMade.compareTo(s1.puttsMade));

  Map<int, int> scoreToPosition = {};
  Map<int, int> scoreToFrequency = {};

  for (int i = 0; i < orderedStandings.length; i++) {
    final int score = orderedStandings[i].puttsMade;
    if (scoreToPosition.containsKey(score)) {
      final int? frequency = scoreToFrequency[score];
      scoreToFrequency[score] = frequency == null ? 1 : frequency + 1;
    } else {
      scoreToPosition[score] = i + 1;
      scoreToFrequency[score] = 1;
    }
  }

  List<OrderedStanding> finalStandings = [];

  for (OrderedStanding orderedStanding in orderedStandings) {
    String positionDescription;
    final int position = scoreToPosition[orderedStanding.puttsMade]!;
    final int frequency = scoreToFrequency[orderedStanding.puttsMade]!;
    positionDescription = '${frequency > 1 ? 'T' : ''}$position';
    finalStandings.add(OrderedStanding(
      eventPlayerData: orderedStanding.eventPlayerData,
      puttsMade: orderedStanding.puttsMade,
      position: positionDescription,
    ));
  }

  return finalStandings;
}

bool isEventAdmin(MyPuttEvent event) {
  final String? currentUid =
      locator.get<FirebaseAuthService>().getCurrentUserId();
  return [event.creatorUid, ...event.adminUids].contains(currentUid);
}

Division getInitialDivision(List<Division> divisions) {
  if (divisions.isNotEmpty) {
    return divisions.first;
  } else {
    return Division.mpo;
  }
}

void openEvent(BuildContext context, MyPuttEvent event) {
  BlocProvider.of<EventStandingsCubit>(context).openEvent(event);
  BlocProvider.of<EventDetailCubit>(context).openEvent(event);
}
