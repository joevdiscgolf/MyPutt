import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';

class ChallengeSummaryStatsPanel extends StatelessWidget {
  const ChallengeSummaryStatsPanel({Key? key, required this.sets})
      : super(key: key);

  final List<PuttingSet> sets;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChallengeTitlePanel extends StatelessWidget {
  const ChallengeTitlePanel({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final int currentUserPuttsMade =
        totalMadeFromSets(challenge.currentUserSets);
    final int opponentPuttsMade = totalMadeFromSets(challenge.opponentSets);
    String resultText;
    final int difference = totalMadeFromSets(challenge.currentUserSets) -
        totalMadeFromSets(challenge.opponentSets);
    Color borderColor;
    if (difference > 0) {
      resultText = "VICTORY";
      borderColor = ThemeColors.lightBlue;
    } else if (difference < 0) {
      resultText = "DEFEAT";
      borderColor = Colors.red;
    } else {
      resultText = "DRAW";
      borderColor = Colors.grey[600]!;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey[200]!,
          border: Border.all(width: 2, color: borderColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(resultText,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    shadows: [
                      const Shadow(
                          color: Colors.black, offset: (Offset(0.3, 0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(-0.3, 0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(0.3, -0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(-0.3, -0.3)))
                    ],
                    color: difference == 0
                        ? Colors.white
                        : (difference > 0)
                            ? ThemeColors.lightBlue
                            : Colors.red)),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[900]!,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: Image(image: blueFrisbeeIcon)),
                Text('$currentUserPuttsMade - $opponentPuttsMade',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                    height: 24, width: 24, child: Image(image: redFrisbeeIcon))
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
