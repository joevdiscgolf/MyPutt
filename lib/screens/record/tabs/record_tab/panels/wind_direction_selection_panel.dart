import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/select_no_condition_row.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/components/condition_selection_row.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/components/wind_direction_icon.dart';
import 'package:myputt/utils/constants/record_constants.dart';
import 'package:myputt/utils/layout_helpers.dart';

class WindDirectionSelectionPanel extends StatefulWidget {
  const WindDirectionSelectionPanel({Key? key}) : super(key: key);

  @override
  State<WindDirectionSelectionPanel> createState() =>
      _WindDirectionSelectionPanelState();
}

class _WindDirectionSelectionPanelState
    extends State<WindDirectionSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
      hasSlidingIndicator: true,
      scrollViewPadding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: addDividers(
          [
            ...WindDirection.values.map(
              (windDirection) {
                return ConditionSelectionRow(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    BlocProvider.of<RecordCubit>(context)
                        .updateWindDirection(windDirection);
                    Navigator.of(context).pop();
                  },
                  icon: WindDirectionIcon(windDirection: windDirection),
                  title: '${windDirectionToNameMap[windDirection]}',
                );
              },
            ),
            SelectNoConditionRow(
              onPressed: () {
                HapticFeedback.lightImpact();
                BlocProvider.of<RecordCubit>(context).updateWindDirection(null);
                Navigator.of(context).pop();
              },
            ),
          ],
          thickness: 2,
        ),
      ),
    );
  }
}
