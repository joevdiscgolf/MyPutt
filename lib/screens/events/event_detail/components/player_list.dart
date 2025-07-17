import 'package:flutter/material.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/ordered_standing.dart';
import 'package:myputt/screens/events/event_detail/components/player_data_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/event_helpers.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    Key? key,
    required this.challengeStructure,
    required this.eventStandings,
    this.isComplete = false,
  }) : super(key: key);

  final List<ChallengeStructureItem> challengeStructure;
  final List<EventPlayerData> eventStandings;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    List<OrderedStanding> orderedStandings =
        getOrderedStandings(eventStandings);

    final List<Widget> children = [
      if (isComplete)
        Container(
          alignment: Alignment.center,
          height: 64,
          decoration: BoxDecoration(
            color: MyPuttColors.blue.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Event complete',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyPuttColors.white),
          ),
        ),
      ...orderedStandings.asMap().entries.map(
            (entry) => PlayerDataRow(
              isFirst: entry.key == 0,
              isLast: entry.key == eventStandings.length - 1,
              position: entry.value.position,
              eventPlayerData: entry.value.eventPlayerData,
              challengeStructure: challengeStructure,
            ),
          ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: isComplete ? 0 : 12, bottom: 12),
      child: Column(children: children),
    );
  }
}
