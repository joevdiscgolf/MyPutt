import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/icons/png_icon.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/circle_icon_container.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/select_no_condition_row.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/wind_direction_selection_panel.dart';
import 'package:myputt/utils/constants/record_constants.dart';
import 'package:myputt/utils/layout_helpers.dart';

class StanceSelectionPanel extends StatefulWidget {
  const StanceSelectionPanel({Key? key}) : super(key: key);

  @override
  State<StanceSelectionPanel> createState() => _StanceSelectionPanelState();
}

class _StanceSelectionPanelState extends State<StanceSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      ...PuttingStance.values.map((puttingStance) {
        return ConditionSelectionRow(
          onPressed: () {
            Vibrate.feedback(FeedbackType.light);
            BlocProvider.of<RecordCubit>(context)
                .updatePuttingStance(puttingStance);
            Navigator.of(context).pop();
          },
          icon: CircleIconContainer(
            icon: PngIcon(
              path: puttingStanceToAssetPathMap[puttingStance] ?? '',
              size: 32,
              flipHorizontal: puttingStance == PuttingStance.straddle,
            ),
          ),
          title: puttingStanceToNameMap[puttingStance] ?? '',
          subtitle: puttingStanceToSubtitleMap[puttingStance],
        );
      }),
      SelectNoConditionRow(
        onPressed: () {
          Vibrate.feedback(FeedbackType.light);
          BlocProvider.of<RecordCubit>(context).updatePuttingStance(null);
          Navigator.of(context).pop();
        },
      ),
    ];
    return BottomSheetPanel(
      hasSlidingIndicator: true,
      scrollViewPadding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: addDividers(children, thickness: 2),
      ),
    );
  }
}
