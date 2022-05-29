import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_enums.dart';

class EventCreateParams {
  EventCreateParams({
    this.name,
    this.description,
    this.verificationRequired,
    this.divisions,
    this.startDate,
    this.endDate,
    this.challengeStructure,
  });
  String? name;
  String? description;
  bool? verificationRequired;
  List<Division>? divisions;
  String? startDate;
  String? endDate;
  List<ChallengeStructureItem>? challengeStructure;
}
