import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';

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
