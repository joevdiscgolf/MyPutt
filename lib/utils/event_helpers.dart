import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/ordered_standing.dart';
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
