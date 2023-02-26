import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/screens/events/components/division_indicator.dart';
import 'package:myputt/screens/events/event_detail/event_detail_screen.dart';

import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/date_helpers.dart';
import 'package:myputt/utils/event_helpers.dart';

class EventListItem extends StatefulWidget {
  const EventListItem({Key? key, required this.event}) : super(key: key);

  final MyPuttEvent event;

  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  late MyPuttEvent _event;

  @override
  void initState() {
    _event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () async {
        openEvent(context, _event);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              event: _event,
              onEventUpdate: (MyPuttEvent updatedEvent) {
                setState(() {
                  _event = updatedEvent;
                });
              },
            ),
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
                      _event.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20, color: MyPuttColors.blue),
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    eventTypeToName[_event.eventType]!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
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
                    .titleLarge
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
                  Expanded(
                    child: _participantCountIndicator(
                        context, _event.participantCount),
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: _event.eventCustomizationData.divisions
                        .map((division) => DivisionIndicator(
                            divisionName: division.name.toUpperCase()))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: Row(
                children: [
                  const Icon(FlutterRemix.clipboard_line,
                      color: MyPuttColors.darkGray, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${_event.creator.displayName}${_event.admins.length > 1 ? '+ ${_event.admins.length - 1} more' : ''}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: MyPuttColors.darkGray,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
        DateTime.fromMillisecondsSinceEpoch(_event.startTimestamp);
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(_event.endTimestamp);

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
          FlutterRemix.user_line,
          color: MyPuttColors.darkGray,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '$numParticipants  players',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: MyPuttColors.darkGray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
