import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
import 'package:myputt/utils/enums.dart';

class PresetsRepository {
  PresetsRepository() {
    presetStructures = {
      ChallengePreset.c1Basics:
          getChallengeStructureByPreset(ChallengePreset.c1Basics, 5),
      ChallengePreset.stepPuttStation:
          getChallengeStructureByPreset(ChallengePreset.stepPuttStation, 5),
      ChallengePreset.twentyFooterClinic:
          getChallengeStructureByPreset(ChallengePreset.twentyFooterClinic, 5),
    };
  }

  Map<ChallengePreset, List<ChallengeStructureItem>> presetStructures = {};

  Map<ChallengePreset, List<GeneratedChallengeItem>> presetInstructions = {
    ChallengePreset.c1Basics: [
      GeneratedChallengeItem(distance: 20, numSets: 3),
      GeneratedChallengeItem(distance: 25, numSets: 3),
      GeneratedChallengeItem(distance: 20, numSets: 3),
      GeneratedChallengeItem(distance: 25, numSets: 3)
    ],
    ChallengePreset.stepPuttStation: [
      GeneratedChallengeItem(distance: 35, numSets: 3),
      GeneratedChallengeItem(distance: 40, numSets: 3),
      GeneratedChallengeItem(distance: 35, numSets: 3),
      GeneratedChallengeItem(distance: 40, numSets: 3)
    ],
    ChallengePreset.twentyFooterClinic: [
      GeneratedChallengeItem(distance: 20, numSets: 10),
    ]
  };

  List<ChallengeStructureItem> getChallengeStructureByPreset(
      ChallengePreset preset, int setLength) {
    switch (preset) {
      case ChallengePreset.c1Basics:
        return generateStructure(ChallengePreset.c1Basics, setLength);
      case ChallengePreset.twentyFooterClinic:
        return generateStructure(ChallengePreset.twentyFooterClinic, setLength);
      case ChallengePreset.stepPuttStation:
        return generateStructure(ChallengePreset.stepPuttStation, setLength);
      default:
        return [];
    }
  }

  List<ChallengeStructureItem> generateStructure(
      ChallengePreset preset, int setLength) {
    List<ChallengeStructureItem> items = [];
    List<GeneratedChallengeItem> instructions =
        presetInstructions[preset] ?? [];
    for (var instruction in instructions) {
      items.addAll([
        for (var i = 0; i < instruction.numSets; i++)
          ChallengeStructureItem(
              distance: instruction.distance, setLength: setLength)
      ]);
    }
    return items;
  }
}
