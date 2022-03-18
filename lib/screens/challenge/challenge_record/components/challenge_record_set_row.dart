import 'package:flutter/material.dart';
import 'package:myputt/screens/home/components/rows/components/shadow_circular_indicator.dart';
import 'package:myputt/utils/colors.dart';

class ChallengeRecordSetRow extends StatelessWidget {
  const ChallengeRecordSetRow(
      {Key? key,
      required this.setNumber,
      required this.currentUserPuttsMade,
      required this.setLength,
      this.opponentPuttsMade})
      : super(key: key);

  final int setNumber;
  final int setLength;
  final int currentUserPuttsMade;
  final int? opponentPuttsMade;

  @override
  Widget build(BuildContext context) {
    print(opponentPuttsMade);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: MyPuttColors.white,
        border: Border(
          top: BorderSide(
            color: MyPuttColors.gray[200]!,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: MyPuttColors.gray[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: ShadowCircularIndicator(
              size: 64,
              decimal: currentUserPuttsMade.toDouble() / setLength.toDouble(),
            ),
          ),
          Flexible(flex: 2, child: _centerColumn(context)),
          Flexible(
            flex: 1,
            child: ShadowCircularIndicator(
              size: 64,
              decimal: opponentPuttsMade != null
                  ? opponentPuttsMade!.toDouble() / setLength.toDouble()
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Set $setNumber',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.gray[800], fontSize: 14),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currentUserPuttsMade/$setLength',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: MyPuttColors.blue, fontSize: 20),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              ':',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: MyPuttColors.gray[800], fontSize: 20),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              '$opponentPuttsMade/$setLength',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: MyPuttColors.red, fontSize: 20),
            )
          ],
        )
      ],
    );
  }
}
