import 'package:flutter/material.dart';

class PerformanceCalendarPanel extends StatefulWidget {
  const PerformanceCalendarPanel({Key? key, required this.onDateChanged})
      : super(key: key);

  final Function onDateChanged;

  @override
  _PerformanceCalendarPanelState createState() =>
      _PerformanceCalendarPanelState();
}

class _PerformanceCalendarPanelState extends State<PerformanceCalendarPanel> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
