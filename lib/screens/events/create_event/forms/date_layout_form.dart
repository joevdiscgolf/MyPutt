import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/screens/events/create_event/components/selector_row.dart';

class DateLayoutForm extends StatefulWidget {
  const DateLayoutForm({
    Key? key,
    required this.onSelectStartDate,
    required this.onSelectStartTime,
    required this.onSelectEndDate,
    required this.onSelectEndTime,
  }) : super(key: key);

  final Function(DateTime) onSelectStartDate;
  final Function(TimeOfDay) onSelectStartTime;
  final Function(DateTime) onSelectEndDate;
  final Function(TimeOfDay) onSelectEndTime;

  static String routeName = '/enter_details';

  @override
  State<DateLayoutForm> createState() => _DateLayoutFormState();
}

class _DateLayoutFormState extends State<DateLayoutForm> {
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Form(
        child: _mainBody(context),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _startDateRow(context),
        const SizedBox(height: 48),
        _endDateRow(context),
      ],
    );
  }

  Widget _startDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectorRow(
            icon: const Icon(FlutterRemix.calendar_event_line),
            text: _startDate == null
                ? 'Start Date'
                : DateFormat.yMd().format(_startDate!),
            onPressed: () async {
              final DateTime? datePicked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (datePicked != null && _verifyStartDate(datePicked)) {
                setState(() => _startDate = datePicked);
                widget.onSelectStartDate(datePicked);
              }
            },
            showArrow: false,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectorRow(
            icon: const Icon(FlutterRemix.time_line),
            text: _startTime == null ? 'Start Time' : _formatTime(_startTime!),
            onPressed: () async {
              final TimeOfDay? timePicked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 0, minute: 0),
              );
              if (timePicked != null) {
                setState(() => _startTime = timePicked);
                widget.onSelectStartTime(timePicked);
              }
            },
            showArrow: false,
          ),
        ),
      ],
    );
  }

  Widget _endDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectorRow(
            icon: const Icon(FlutterRemix.calendar_check_line),
            text: _endDate == null
                ? 'End Date'
                : DateFormat.yMd().format(_endDate!),
            onPressed: () async {
              final DateTime? datePicked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (datePicked != null && _verifyEndDate(datePicked)) {
                setState(() => _endDate = datePicked);
                widget.onSelectEndDate(datePicked);
              }
            },
            showArrow: false,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectorRow(
            icon: const Icon(FlutterRemix.time_line),
            text: _endTime == null ? 'End Time' : _formatTime(_endTime!),
            onPressed: () async {
              final TimeOfDay? timePicked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 0, minute: 0),
              );
              if (timePicked != null) {
                setState(() => _endTime = timePicked);
                widget.onSelectEndTime(timePicked);
              }
            },
            showArrow: false,
          ),
        ),
      ],
    );
  }

  bool _verifyStartDate(DateTime startDate) {
    final DateTime? end = _endDate;
    if (end == null) {
      return true;
    }
    if (_startTime != null) {
      end.add(Duration(hours: _startTime!.hour, minutes: _startTime!.minute));
    }
    if (_endTime != null) {
      startDate.add(Duration(hours: _endTime!.hour, minutes: _endTime!.minute));
    }
    return end.millisecondsSinceEpoch > startDate.millisecondsSinceEpoch;
  }

  bool _verifyEndDate(DateTime endDate) {
    final DateTime? start = _startDate;
    if (start == null) {
      return true;
    }
    if (_startTime != null) {
      start.add(Duration(hours: _startTime!.hour, minutes: _startTime!.minute));
    }
    if (_endTime != null) {
      endDate.add(Duration(hours: _endTime!.hour, minutes: _endTime!.minute));
    }
    return endDate.millisecondsSinceEpoch >= start.millisecondsSinceEpoch;
  }

  String _formatTime(TimeOfDay time) {
    String hour;
    String minute;
    if (time.hour < 10) {
      hour = '0${time.hour}';
    } else {
      hour = '${time.hour}';
    }
    if (time.minute < 10) {
      minute = '0${time.minute}';
    } else {
      minute = '${time.minute}';
    }
    return '$hour:$minute';
  }
}
