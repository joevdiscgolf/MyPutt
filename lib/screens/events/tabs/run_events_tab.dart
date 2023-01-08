import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/components/event_search_loading_screen.dart';
import 'package:myputt/screens/events/components/events_list.dart';
import 'package:myputt/services/events_service.dart';

class RunEventsTab extends StatefulWidget {
  const RunEventsTab({Key? key}) : super(key: key);

  @override
  State<RunEventsTab> createState() => _RunEventsTabState();
}

class _RunEventsTabState extends State<RunEventsTab>
    with AutomaticKeepAliveClientMixin {
  final EventsService _eventsService = locator.get<EventsService>();
  late Future<void> _fetchData;

  late List<MyPuttEvent> _myEvents;
  bool _error = false;
  bool _loading = false;

  Future<void> _initData() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      _myEvents = await _eventsService
          .getMyEvents()
          .then((response) => response.events);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _fetchData = _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<void>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_loading) {
              return const EventSearchLoadingScreen();
            } else if (_error) {
              return EmptyState(
                icon: const Icon(FlutterRemix.stack_line, size: 32),
                title: "Network error.",
                subtitle: "Please check your connection and try again.",
                onRetry: () => _fetchData = _initData(),
              );
            }
            return EventsList(
              events: _myEvents,
              onRefresh: () => _fetchData = _initData(),
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
