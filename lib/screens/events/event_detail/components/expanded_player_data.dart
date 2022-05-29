import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/screens/home/components/stats_view/rows/components/shadow_circular_indicator.dart';
import 'package:myputt/utils/colors.dart';

class ExpandedPlayerData extends StatelessWidget {
  const ExpandedPlayerData({
    Key? key,
    required this.playerData,
    required this.challengeStructure,
  }) : super(key: key);

  final EventPlayerData playerData;
  final List<ChallengeStructureItem> challengeStructure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: MyPuttColors.gray[200]!,
          ),
        ),
      ),
      child: Column(
        children: [
          if (playerData.usermetadata.pdgaNum != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${playerData.usermetadata.pdgaNum}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: MyPuttColors.gray[400], fontSize: 16),
                    ),
                  ),
                  if (playerData.usermetadata.pdgaRating != null)
                    Text(
                      'Rating: ${playerData.usermetadata.pdgaRating}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: MyPuttColors.gray[400], fontSize: 16),
                    ),
                ],
              ),
            ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _setsRow(context),
                  _scoreRow(context),
                  _distRow(context),
                  _statsRow(context),
                ],
              )),
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statsColumn(context, 0.6, 'Circle 1'),
          _statsColumn(context, 0.6, 'Circle 2'),
          _statsColumn(context, 0.6, 'Overall'),
        ],
      ),
    );
  }

  Widget _statsColumn(BuildContext context, double decimal, String message) {
    return Column(
      children: [
        ShadowCircularIndicator(
          size: 72,
          decimal: decimal,
          animate: true,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.darkGray, fontSize: 14),
        )
      ],
    );
  }

  Widget _setsRow(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        width: 64,
        child: Text(
          'Set',
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: MyPuttColors.darkGray,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
      )
    ];

    children.addAll(challengeStructure.asMap().entries.map((entry) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 40,
          child: Text(
            '${entry.key + 1}',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )));

    return Container(
      color: MyPuttColors.gray[50],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: children,
      ),
    );
  }

  Widget _scoreRow(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        width: 64,
        child: Text(
          'Score',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: MyPuttColors.darkGray,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
        ),
      )
    ];

    children.addAll(challengeStructure.asMap().entries.map((entry) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: 40,
        child: Builder(builder: (BuildContext context) {
          final int setLength = entry.value.setLength;
          final int? puttsMade = playerData.sets.length > entry.key
              ? playerData.sets[entry.key].puttsMade
              : null;
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${puttsMade ?? '--'}/',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontSize: 14,
                      ),
                ),
                TextSpan(
                  text: '$setLength',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontSize: 14,
                      ),
                )
              ],
            ),
          );
        }))));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: children,
      ),
    );
  }

  Widget _distRow(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        width: 64,
        child: Text(
          'Dist',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: MyPuttColors.darkGray,
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
      )
    ];

    children.addAll(challengeStructure.map((structureItem) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 40,
          child: Text(
            '${structureItem.distance}ft',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )));

    return Container(
      color: MyPuttColors.gray[50],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: children,
      ),
    );
  }
}
