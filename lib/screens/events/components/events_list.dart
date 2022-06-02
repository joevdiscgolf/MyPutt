import 'package:flutter/material.dart';
import 'package:myputt/data/types/events/myputt_event.dart';

import 'event_list_item.dart';

class EventsList extends StatelessWidget {
  const EventsList({
    Key? key,
    required this.events,
    required this.onPressed,
  }) : super(key: key);

  final List<MyPuttEvent> events;
  final Function(MyPuttEvent) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: events.isNotEmpty
          ? ListView(
              children: events
                  .map((event) => EventListItem(
                        event: event,
                        onPressed: (MyPuttEvent event) => onPressed(event),
                      ))
                  .toList(),
            )
          : LayoutBuilder(
              builder: (BuildContext context, constraints) => ListView(
                children: [
                  Container(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(
                      child: Text('No events'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
