import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/ordered_standing.dart';
import 'package:myputt/screens/events/event_detail/components/player_data_row.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/utils/event_helpers.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    Key? key,
    required this.challengeStructure,
    required this.eventStandings,
  }) : super(key: key);

  final List<ChallengeStructureItem> challengeStructure;
  final List<EventPlayerData> eventStandings;

  @override
  Widget build(BuildContext context) {
    // List<EventPlayerData> standings = [];
    // for (int i = 0; i < 20; i++) {
    //   standings.add(EventPlayerData(
    //       usermetadata: eventStandings[0].usermetadata,
    //       sets: eventStandings[0].sets,
    //       lockedIn: false,
    //       division: Division.mpo));
    // }

    List<OrderedStanding> orderedStandings =
        getOrderedStandings(eventStandings);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: orderedStandings
          .asMap()
          .entries
          .map((entry) => PlayerDataRow(
                isFirst: entry.key == 0,
                isLast: entry.key == eventStandings.length - 1,
                position: entry.value.position,
                eventPlayerData: entry.value.eventPlayerData,
                challengeStructure: challengeStructure,
              ))
          .toList(),
    );
  }
}
