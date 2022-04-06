import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/events/myputt_event.dart';

import 'package:myputt/utils/colors.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  final MyPuttEvent event;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {},
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
                color: MyPuttColors.gray[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 2),
                      color: MyPuttColors.gray[400]!,
                      blurRadius: 2)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          event.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 20, color: MyPuttColors.blue),
                        ),
                      ),
                    ),
                    _participantCountIndicator(context, 50)
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ends ${DateFormat.yMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(event.completionTimestamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(event.completionTimestamp))}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 12, color: MyPuttColors.darkGray),
                ),
              ],
            )));
  }

  Widget _participantCountIndicator(BuildContext context, int numParticipants) {
    return Column(
      children: [
        Text('$numParticipants',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 12, color: MyPuttColors.darkGray)),
        const Icon(
          FlutterRemix.user_fill,
          color: MyPuttColors.darkGray,
          size: 12,
        )
      ],
    );
  }
}
