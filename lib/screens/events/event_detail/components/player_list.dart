import 'package:flutter/material.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/data/endpoints/events/event_endpoints.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/events/event_detail/components/player_data_row.dart';
import 'package:myputt/services/events_service.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({Key? key, required this.event, required this.division})
      : super(key: key);

  final MyPuttEvent event;
  final Division division;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final EventsService _eventsService = locator.get<EventsService>();
  late Future<void> _fetchData;
  List<EventPlayerData>? _eventStandings;

  @override
  void initState() {
    _fetchData = _initData();
    super.initState();
  }

  Future<void> _initData() async {
    await _eventsService
        .getEventStandings(widget.event.id, division: widget.division)
        .then((response) => _eventStandings = response.eventStandings);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<void>(
        future: _fetchData,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                if (snapshot.hasError || _eventStandings == null) {
                  return EmptyState(onRetry: _initData);
                }
                return _mainBody(context);
              }
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
              return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: _eventStandings!
            .map((eventPlayerData) =>
                PlayerDataRow(eventPlayerData: eventPlayerData))
            .toList(),
      ),
    );
  }
}
