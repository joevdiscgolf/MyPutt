import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/utils/colors.dart';

class StructureDescriptionRow extends StatelessWidget {
  const StructureDescriptionRow({
    Key? key,
    required this.generatedChallengeInstruction,
    this.onDelete,
  }) : super(key: key);

  final GeneratedChallengeInstruction generatedChallengeInstruction;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: _shadowChip(
                  context, '${generatedChallengeInstruction.distance} ft')),
          _multiplyIcon(context),
          Expanded(
              child: _shadowChip(
                  context, '${generatedChallengeInstruction.setCount} sets')),
          _multiplyIcon(context),
          Expanded(
              child: _shadowChip(
                  context, '${generatedChallengeInstruction.setLength} putts')),
          if (onDelete != null)
            CloseButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onDelete!();
              },
              color: MyPuttColors.red,
            )
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
        ],
      ),
      child: Center(
        child: AutoSizeText(
          text,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 14, color: MyPuttColors.darkGray),
          maxLines: 1,
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
