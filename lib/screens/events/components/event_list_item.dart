import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/cubits/events/events_cubit.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/screens/events/components/division_indicator.dart';
import 'package:myputt/screens/events/event_detail/event_detail_screen.dart';

import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/date_helpers.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  final MyPuttEvent event;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () async {
          BlocProvider.of<EventsCubit>(context).openEvent(event);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: MyPuttColors.gray[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    color: MyPuttColors.gray[400]!,
                    blurRadius: 2)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          event.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 20, color: MyPuttColors.blue),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        eventTypeToName[event.eventType]!,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontSize: 16, color: MyPuttColors.darkGray),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _dateLabel(context),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
                  ),
                ),
                const SizedBox(height: 16),
                _image(context),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(child: _participantCountIndicator(context, 50)),
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: event.divisions
                            .map((division) => DivisionIndicator(
                                  divisionName: division.name.toUpperCase(),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget _image(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.srcOver),
          image: const AssetImage(kDefaultEventImgPath),
        ),
      ),
    );
  }

  String _dateLabel(BuildContext context) {
    String dateText;
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(event.startTimestamp);
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(event.endTimestamp);

    if (isSameDate(startDate, endDate)) {
      dateText =
          '${DateFormat.MMMd('en_US').format(startDate)}, ${startDate.year}';
    } else if (startDate.year != endDate.year) {
      dateText =
          '${DateFormat.MMMd('en_US').format(startDate)} ${startDate.year} - ${DateFormat.MMMd('en_US').format(endDate)}, ${endDate.year}';
    } else if (startDate.month != endDate.month) {
      dateText =
          '${DateFormat.MMMd('en_US').format(startDate)} - ${DateFormat.MMMd('en_US').format(endDate)}, ${startDate.year}';
    } else {
      dateText =
          '${DateFormat.MMMM('en_US').format(startDate)} ${DateFormat.d('en_US').format(startDate)} - ${DateFormat.d('en_US').format(endDate)}, ${startDate.year}';
    }
    return dateText;
  }

  Widget _participantCountIndicator(BuildContext context, int numParticipants) {
    return Row(
      children: [
        const Icon(
          FlutterRemix.user_fill,
          color: MyPuttColors.darkGray,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text('$numParticipants',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 12, color: MyPuttColors.darkGray)),
      ],
    );
  }
}
