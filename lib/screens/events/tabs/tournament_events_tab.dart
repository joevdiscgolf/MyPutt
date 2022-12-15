import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/events/event_detail_cubit.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/screens/events/event_detail/event_detail_screen.dart';
import 'package:myputt/utils/constants.dart';

class TournamentEventsTab extends StatefulWidget {
  const TournamentEventsTab({Key? key}) : super(key: key);

  @override
  State<TournamentEventsTab> createState() => _TournamentEventsTabState();
}

class _TournamentEventsTabState extends State<TournamentEventsTab> {
  @override
  Widget build(BuildContext context) {
    return EventsList(
      events: kTestEvents,
      onPressed: (MyPuttEvent event) {
        BlocProvider.of<EventDetailCubit>(context).openEvent(event);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      onRefresh: () {},
    );
  }
}
