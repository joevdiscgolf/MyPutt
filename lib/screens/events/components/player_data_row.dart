import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';

class PlayerDataRow extends StatelessWidget {
  PlayerDataRow({Key? key, required this.eventPlayerData}) : super(key: key);

  final EventPlayerData eventPlayerData;
  final StatsService _statsService = locator.get<StatsService>();

  @override
  Widget build(BuildContext context) {
    final int puttsAttempted = totalAttemptsFromSets(eventPlayerData.sets);
    final int puttsMade = totalMadeFromSets(eventPlayerData.sets);
    print(_statsService.statsFromSets(eventPlayerData.sets).toJson());
    return Bounceable(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
                top: BorderSide(width: 1, color: MyPuttColors.gray[100]!),
                bottom: BorderSide(width: 1, color: MyPuttColors.gray[100]!))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: AutoSizeText(
                  '1',
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
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              child: Column(
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
            const Spacer(),
            SizedBox(
                width: 64,
                child: Text(
                  '$puttsMade/$puttsAttempted',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }
}
