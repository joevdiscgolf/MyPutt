import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/empty_state/empty_state.dart';
import 'package:myputt/components/screens/loading_screen.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

class PerformanceCalendarPanel extends StatefulWidget {
  const PerformanceCalendarPanel({Key? key, required this.onDateChanged})
      : super(key: key);

  final Function onDateChanged;

  @override
  _PerformanceCalendarPanelState createState() =>
      _PerformanceCalendarPanelState();
}

class _PerformanceCalendarPanelState extends State<PerformanceCalendarPanel> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      Vibrate.feedback(FeedbackType.light);
      widget.onDateChanged(selectedDay);
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenLoaded) {
          return TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: (DateTime dateTime) => state.events
                .where((event) => isSameDay(dateTime, event.dateTime))
                .toList(),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          );
        } else if (state is HomeScreenInitial || state is HomeScreenLoading) {
          return const LoadingScreen();
        } else {
          return EmptyState(
              onRetry: () =>
                  BlocProvider.of<HomeScreenCubit>(context).reload());
        }
      },
    );
  }
}
