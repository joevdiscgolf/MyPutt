import 'package:flutter/material.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/components/panels/panel_header.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/screens/events/event_detail/components/panels/event_division_row.dart';

class UpdateDivisionPanel extends StatelessWidget {
  const UpdateDivisionPanel({
    Key? key,
    required this.currentDivision,
    required this.availableDivisions,
    required this.onDivisionUpdate,
  }) : super(key: key);

  final List<Division> availableDivisions;
  final Division currentDivision;
  final Function onDivisionUpdate;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const PanelHeader(title: 'Choose division'),
      const SizedBox(height: 24)
    ];
    children.addAll(availableDivisions.map((division) => EventDivisionRow(
          division: division,
          onDivisionTap: (Division division) {
            onDivisionUpdate(division);
            Navigator.of(context).pop();
          },
        )));
    return BottomSheetPanel(child: Column(children: children));
  }
}
