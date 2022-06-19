import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/enums.dart';

class PresetsRepository {
  PresetsRepository() {
    presetStructures = {
      ChallengePreset.c1Basics:
          getChallengeStructureByPreset(ChallengePreset.c1Basics),
      ChallengePreset.stepPuttStation:
          getChallengeStructureByPreset(ChallengePreset.stepPuttStation),
      ChallengePreset.twentyFooterClinic:
          getChallengeStructureByPreset(ChallengePreset.twentyFooterClinic),
    };
  }

  Map<ChallengePreset, List<ChallengeStructureItem>> presetStructures = {};

  Map<ChallengePreset, List<GeneratedChallengeInstruction>> presetInstructions =
      {
    ChallengePreset.c1Basics: [
      GeneratedChallengeInstruction(distance: 20, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 25, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 20, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 25, setCount: 3, setLength: 10)
    ],
    ChallengePreset.stepPuttStation: [
      GeneratedChallengeInstruction(distance: 35, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 40, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 35, setCount: 3, setLength: 10),
      GeneratedChallengeInstruction(distance: 40, setCount: 3, setLength: 10)
    ],
    ChallengePreset.twentyFooterClinic: [
      GeneratedChallengeInstruction(distance: 20, setCount: 10, setLength: 10),
    ]
  };

  List<ChallengeStructureItem> getChallengeStructureByPreset(
      ChallengePreset preset) {
    switch (preset) {
      case ChallengePreset.c1Basics:
        return generateStructureFromPreset(ChallengePreset.c1Basics);
      case ChallengePreset.twentyFooterClinic:
        return generateStructureFromPreset(ChallengePreset.twentyFooterClinic);
      case ChallengePreset.stepPuttStation:
        return generateStructureFromPreset(ChallengePreset.stepPuttStation);
      default:
        return [];
    }
  }

  List<ChallengeStructureItem> generateStructureFromPreset(
      ChallengePreset preset) {
    List<GeneratedChallengeInstruction> instructions =
        presetInstructions[preset] ?? [];
    return challengeStructureFromInstructions(instructions);
  }
}
