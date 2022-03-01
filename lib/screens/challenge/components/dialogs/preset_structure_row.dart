import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/utils/enums.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/theme/theme_data.dart';

class PresetStructureRow extends StatelessWidget {
  const PresetStructureRow(
      {Key? key,
      required this.presetType,
      required this.structure,
      this.selected = false,
      required this.onTap})
      : super(key: key);

  final ChallengePreset presetType;
  final List<ChallengeStructureItem> structure;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!selected) {
          onTap(presetType);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: selected ? Colors.blue[200] : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2, color: Colors.grey[400]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(presetType.name),
          ],
        ),
      ),
    );
  }
}
