import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/utils/colors.dart';

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
      child: CustomScrollView(
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
                if (events.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FlutterRemix.stack_line, size: 40),
                      const SizedBox(height: 16),
                      Text(
                        'No events yet',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: MyPuttColors.darkGray),
                      ),
                    ],
                  );
                }

                return Column(
                  children: events
                      .map((event) => EventListItem(
                            event: event,
                            onPressed: (MyPuttEvent event) => onPressed(event),
                          ))
                      .toList(),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
