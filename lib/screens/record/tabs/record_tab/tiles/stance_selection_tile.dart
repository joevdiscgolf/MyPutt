import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/stance_selection_panel.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/record_constants.dart';
import 'package:myputt/utils/panel_helpers.dart';

class StanceSelectionTile extends StatelessWidget {
  const StanceSelectionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Stance',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w600,
                color: MyPuttColors.gray[400],
              ),
        ),
        const SizedBox(height: 8),
        Bounceable(
          onTap: () {
            Vibrate.feedback(FeedbackType.light);
            displayBottomSheet(context, const StanceSelectionPanel());
          },
          child: SelectionTile(
            child: Container(
              alignment: Alignment.center,
              child: BlocBuilder<RecordCubit, RecordState>(
                builder: (context, state) {
                  return Text(
                    _titleText(state.puttingConditions.puttingStance),
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _titleColor(
                            state.puttingConditions.puttingStance,
                          ),
                        ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _titleText(PuttingStance? stance) {
    if (stance == null) {
      return 'Select';
    } else {
      return puttingStanceToNameMap[stance] ?? '';
    }
  }

  Color _titleColor(PuttingStance? stance) {
    if (stance == null) {
      return MyPuttColors.blue;
    } else {
      return MyPuttColors.gray[800]!;
    }
  }
}
