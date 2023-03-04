import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/wind_direction_selection_panel.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/record_constants.dart';
import 'package:myputt/utils/panel_helpers.dart';

class WindDirectionTile extends StatelessWidget {
  const WindDirectionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Wind',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w600,
                color: MyPuttColors.gray[400],
              ),
        ),
        const SizedBox(height: 8),
        Bounceable(
          onTap: () {
            Vibrate.feedback(FeedbackType.light);
            displayBottomSheet(context, const WindDirectionSelectionPanel());
          },
          child: SelectionTile(
            child: Container(
              alignment: Alignment.center,
              child: BlocBuilder<RecordCubit, RecordState>(
                builder: (context, state) {
                  return Text(
                    _titleText(state.puttingConditions.windDirection),
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _titleColor(
                            state.puttingConditions.windDirection,
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

  String _titleText(WindDirection? windDirection) {
    if (windDirection == null) {
      return 'Select';
    } else {
      return windDirectionToNameMap[windDirection] ?? '';
    }
  }

  Color _titleColor(WindDirection? windDirection) {
    if (windDirection == null) {
      return MyPuttColors.blue;
    } else {
      return MyPuttColors.gray[800]!;
    }
  }
}
