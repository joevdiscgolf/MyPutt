import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/date_helpers.dart';

class EventDetailsPanel extends StatelessWidget {
  const EventDetailsPanel(
      {Key? key,
      required this.event,
      required this.onDivisionUpdate,
      required this.division,
      this.textColor = MyPuttColors.darkGray})
      : super(key: key);

  final MyPuttEvent event;
  final Function onDivisionUpdate;
  final Division division;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _dateLabel(context),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16, color: textColor),
          ),
        ],
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
}
