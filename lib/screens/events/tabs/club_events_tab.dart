import 'package:flutter/material.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/utils/constants.dart';

class ClubEventsTab extends StatefulWidget {
  const ClubEventsTab({Key? key}) : super(key: key);

  @override
  State<ClubEventsTab> createState() => _ClubEventsTabState();
}

class _ClubEventsTabState extends State<ClubEventsTab> {
  @override
  Widget build(BuildContext context) {
    return EventsList(events: kTestEvents);
  }
}
