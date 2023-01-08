import 'package:flutter/material.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/utils/constants.dart';

class TournamentEventsTab extends StatefulWidget {
  const TournamentEventsTab({Key? key}) : super(key: key);

  @override
  State<TournamentEventsTab> createState() => _TournamentEventsTabState();
}

class _TournamentEventsTabState extends State<TournamentEventsTab> {
  @override
  Widget build(BuildContext context) {
    return EventsList(events: kTestEvents);
  }
}
