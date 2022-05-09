import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/screens/events/event_detail/components/panels/update_division_panel.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/date_helpers.dart';
import 'package:myputt/utils/panel_helpers.dart';

class EventDetailsPanel extends StatefulWidget {
  const EventDetailsPanel(
      {Key? key,
      required this.event,
      required this.onDivisionUpdate,
      required this.division})
      : super(key: key);

  final MyPuttEvent event;
  final Function onDivisionUpdate;
  final Division division;

  @override
  State<EventDetailsPanel> createState() => _EventDetailsPanelState();
}

class _EventDetailsPanelState extends State<EventDetailsPanel> {
  late Division _currentDivision;

  @override
  void initState() {
    _currentDivision = widget.division;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.name,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color: MyPuttColors.darkGray,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _dateLabel(context),
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
          ),
        ],
      ),
    );
  }

  String _dateLabel(BuildContext context) {
    String dateText;
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(widget.event.startTimestamp);
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(widget.event.endTimestamp);

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
