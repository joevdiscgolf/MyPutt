import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/screens/events/event_detail/components/expanded_player_data.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';

class PlayerDataRow extends StatelessWidget {
  const PlayerDataRow({
    Key? key,
    required this.position,
    required this.challengeStructure,
    required this.eventPlayerData,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  final String position;
  final List<ChallengeStructureItem> challengeStructure;
  final EventPlayerData eventPlayerData;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => Vibrate.feedback(FeedbackType.light),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 1, color: MyPuttColors.gray[100]!))),
        child: ExpandableTheme(
          data: const ExpandableThemeData(
            animationDuration: Duration(milliseconds: 200),
            tapBodyToExpand: true,
            iconPadding: EdgeInsets.only(left: 8, right: 24),
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            alignment: Alignment.center,
            iconSize: 20,
            iconColor: MyPuttColors.darkGray,
          ),
          child: ExpandableNotifier(
            initialExpanded: false,
            child: ExpandablePanel(
              header: _mainRow(context),
              collapsed: const SizedBox(height: 0),
              expanded: ExpandedPlayerData(
                challengeStructure: challengeStructure,
                playerData: eventPlayerData,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainRow(BuildContext context) {
    final int puttsAttempted = totalAttemptsFromSets(eventPlayerData.sets);
    final int puttsMade = totalMadeFromSets(eventPlayerData.sets);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: AutoSizeText(
                position,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: MyPuttColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FrisbeeCircleIcon(
            size: 40,
            iconSize: 20,
            frisbeeAvatar: eventPlayerData.usermetadata.frisbeeAvatar,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              width: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    eventPlayerData.usermetadata.displayName,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    '@${eventPlayerData.usermetadata.username}',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: MyPuttColors.gray[400],
                          fontSize: 12,
                        ),
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
              width: 64,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$puttsMade/',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: MyPuttColors.darkBlue,
                            fontSize: 14,
                          ),
                    ),
                    TextSpan(
                      text: '$puttsAttempted',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: MyPuttColors.darkGray,
                            fontSize: 14,
                          ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
