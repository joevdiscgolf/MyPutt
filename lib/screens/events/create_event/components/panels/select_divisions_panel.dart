import 'package:flutter/material.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/components/panels/panel_header.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/components/panels/division_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class SelectDivisionsPanel extends StatefulWidget {
  const SelectDivisionsPanel({
    Key? key,
    required this.onDivisionSelected,
    required this.initialDivisions,
  }) : super(key: key);

  final List<Division> initialDivisions;
  final Function onDivisionSelected;

  @override
  State<SelectDivisionsPanel> createState() => _SelectDivisionsPanelState();
}

class _SelectDivisionsPanelState extends State<SelectDivisionsPanel> {
  late List<Division> _selectedDivisions;

  @override
  void initState() {
    _selectedDivisions = widget.initialDivisions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      const PanelHeader(title: 'Select divisions'),
      const SizedBox(height: 16),
      DivisionRow(
        division: Division.everyone,
        selected: _selectedDivisions.contains(Division.everyone),
        onPressed: () => setState(
          () {
            if (_selectedDivisions.contains(Division.everyone)) {
              _selectedDivisions.remove(Division.everyone);
            } else {
              _selectedDivisions.add(Division.everyone);
            }
            widget.onDivisionSelected(_selectedDivisions);
          },
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Professional',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 16,
              color: MyPuttColors.darkGray,
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 16),
    ];

    final List<Widget> professional = proDivisions
        .map(
          (Division division) => DivisionRow(
            division: division,
            selected: _selectedDivisions.contains(division),
            onPressed: () => setState(
              () {
                if (_selectedDivisions.contains(division)) {
                  _selectedDivisions.remove(division);
                } else {
                  _selectedDivisions.add(division);
                }
                widget.onDivisionSelected(_selectedDivisions);
              },
            ),
          ),
        )
        .toList();

    children.add(
      Wrap(
        alignment: WrapAlignment.start,
        children: professional,
      ),
    );
    final List<Widget> amateur = amateurDivisions
        .map(
          (Division division) => DivisionRow(
            division: division,
            selected: _selectedDivisions.contains(division),
            onPressed: () {
              setState(
                () {
                  if (_selectedDivisions.contains(division)) {
                    _selectedDivisions.remove(division);
                  } else {
                    _selectedDivisions.add(division);
                  }
                },
              );
              widget.onDivisionSelected(_selectedDivisions);
            },
          ),
        )
        .toList();

    children.addAll(
      [
        const SizedBox(height: 24),
        Text(
          'Amateur',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 16,
                color: MyPuttColors.darkGray,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.start,
          children: amateur,
        )
      ],
    );

    return BottomSheetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
