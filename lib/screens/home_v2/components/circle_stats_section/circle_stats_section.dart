import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/screens/home_v2/components/circle_stats_section/circle_stats_card.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/enums.dart';

class CircleStats extends StatelessWidget {
  const CircleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Circles, List<PuttingSetsInterval>> circleToSetsIntervals =
        locator.get<StatsService>().getSetIntervals(
              locator.get<StatsService>().getSetsByDistance(
                    locator.get<SessionRepository>().validCompletedSessions,
                    locator.get<ChallengesRepository>().completedChallenges,
                  ),
            );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: CircleStatsCard(
              circle: Circles.circle1,
              setIntervals: circleToSetsIntervals[Circles.circle1] ?? [],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CircleStatsCard(
              circle: Circles.circle2,
              setIntervals: circleToSetsIntervals[Circles.circle2] ?? [],
            ),
          )
        ],
      ),
    );
  }
}
