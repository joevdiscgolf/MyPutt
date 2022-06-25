import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/events/myputt_event.dart';

import 'event_list_item.dart';

class EventsList extends StatelessWidget {
  const EventsList({
    Key? key,
    required this.events,
    required this.onPressed,
    this.onRefresh,
  }) : super(key: key);

  final List<MyPuttEvent> events;
  final Function(MyPuttEvent) onPressed;
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: events.isNotEmpty
          ? CustomScrollView(
              slivers: [
                if (onRefresh != null)
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      Vibrate.feedback(FeedbackType.light);
                      onRefresh!();
                    },
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: events
                            .map((event) => EventListItem(
                                  event: event,
                                  onPressed: (MyPuttEvent event) =>
                                      onPressed(event),
                                ))
                            .toList(),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
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
