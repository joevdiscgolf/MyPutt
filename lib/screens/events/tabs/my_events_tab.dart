import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/components/event_search_loading_screen.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/services/events_service.dart';

class MyEventsTab extends StatefulWidget {
  const MyEventsTab({Key? key}) : super(key: key);

  @override
  State<MyEventsTab> createState() => _MyEventsTabState();
}

class _MyEventsTabState extends State<MyEventsTab> {
  final EventsService _eventsService = locator.get<EventsService>();
  late Future<void> _fetchData;

  late List<MyPuttEvent> _myEvents;

  Future<void> _initData() async {
    _myEvents =
        await _eventsService.getMyEvents().then((response) => response.events);
  }

  @override
  void initState() {
    _fetchData = _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_myEvents.isEmpty) {
              return EmptyState(
                icon: const Icon(
                  FlutterRemix.stack_line,
                  size: 32,
                ),
                title: "We couldn't find any events",
                onRetry: () => _fetchData = _initData(),
              );
            }
            return EventsList(
              events: _myEvents,
              onPressed: (MyPuttEvent event) {},
            );
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          default:
            return const EventSearchLoadingScreen();
        }
      },
    );
  }
}
