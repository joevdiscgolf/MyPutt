import 'package:flutter/material.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/screens/events/event_detail/components/player_data_row.dart';
import 'package:myputt/data/types/events/event_enums.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    Key? key,
    required this.eventStandings,
  }) : super(key: key);

  final List<EventPlayerData> eventStandings;

  @override
  Widget build(BuildContext context) {
    List<EventPlayerData> standings = [];
    for (int i = 0; i < 20; i++) {
      standings.add(EventPlayerData(
          usermetadata: eventStandings[0].usermetadata,
          sets: [],
          lockedIn: false,
          division: Division.mpo));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: standings
          .asMap()
          .entries
          .map((entry) => PlayerDataRow(
                isFirst: entry.key == 0,
                isLast: entry.key == standings.length - 1,
                eventPlayerData: entry.value,
              ))
          .toList(),
    );
  }
}
