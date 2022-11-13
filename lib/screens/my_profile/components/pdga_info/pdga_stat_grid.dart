import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/models/data/users/pdga_player_info.dart';

import 'pdga_stat_tile.dart';

class PDGAStatGrid extends StatelessWidget {
  const PDGAStatGrid({Key? key, required this.playerInfo}) : super(key: key);

  final PDGAPlayerInfo playerInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PdgaStatTile(
                    description: '${playerInfo.pdgaNum ?? '---'}',
                    value: 'PDGA Number',
                    iconData: FlutterRemix.hashtag),
              ),
              Expanded(
                child: PdgaStatTile(
                    description: 'Class',
                    value: playerInfo.classification ?? '---',
                    iconData: FlutterRemix.medal_line),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: PdgaStatTile(
                    description: 'Rating',
                    value: '${playerInfo.rating ?? '---'}',
                    iconData: FlutterRemix.bar_chart_line),
              ),
              Expanded(
                child: PdgaStatTile(
                    description: 'Since',
                    value: playerInfo.memberSince ?? '---',
                    iconData: FlutterRemix.time_line),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: PdgaStatTile(
                    description: 'Events',
                    value:
                        '${playerInfo.careerEvents ?? '---'} events, ${playerInfo.careerWins ?? '---'} wins',
                    iconData: FlutterRemix.calendar_event_fill),
              ),
              Expanded(
                child: PdgaStatTile(
                    description: 'Earnings',
                    value: '\$${playerInfo.careerEarnings ?? '---'}',
                    iconData: FlutterRemix.money_dollar_circle_line),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
