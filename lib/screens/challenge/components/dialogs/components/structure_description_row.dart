import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
import 'package:myputt/utils/colors.dart';

class StructureDescriptionRow extends StatelessWidget {
  const StructureDescriptionRow(
      {Key? key, required this.generatedChallengeItem})
      : super(key: key);

  final GeneratedChallengeItem generatedChallengeItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: _shadowChip(
                  context, '${generatedChallengeItem.distance} ft')),
          _multiplyIcon(context),
          Expanded(
              child: _shadowChip(
                  context, '${generatedChallengeItem.numSets} sets')),
          _multiplyIcon(context),
          Expanded(child: _shadowChip(context, '10 putts')),
        ],
      ),
    );
  }

  Widget _shadowChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: MyPuttColors.gray[50],
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 1,
                color: MyPuttColors.gray[400]!)
          ]),
      child: Center(
        child: AutoSizeText(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 14, color: MyPuttColors.darkGray),
        ),
      ),
    );
  }

  Widget _multiplyIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Icon(
        FlutterRemix.close_line,
        color: MyPuttColors.blue,
        size: 16,
      ),
    );
  }
}
