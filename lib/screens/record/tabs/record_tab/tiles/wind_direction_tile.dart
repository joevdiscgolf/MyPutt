import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/components/wind_direction_icon.dart';
import 'package:myputt/screens/record/tabs/record_tab/panels/wind_direction_selection_panel.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/record_constants.dart';
import 'package:myputt/utils/panel_helpers.dart';

class WindDirectionTile extends StatelessWidget {
  const WindDirectionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        final WindDirection? windDirection =
            state.puttingConditions.windDirection;
        return Column(
          children: [
            Text(
              _titleText(windDirection),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MyPuttColors.gray[400],
                  ),
            ),
            const SizedBox(height: 8),
            Bounceable(
              onTap: () {
                Vibrate.feedback(FeedbackType.light);
                displayBottomSheet(
                    context, const WindDirectionSelectionPanel());
              },
              child: SelectionTile(
                child: Container(
                    alignment: Alignment.center,
                    child: Builder(
                      builder: (context) {
                        if (windDirection != null) {
                          return WindDirectionIcon(
                            windDirection: windDirection,
                          );
                        } else {
                          return Text(
                            'Select',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: MyPuttColors.blue,
                                ),
                            textAlign: TextAlign.center,
                          );
                        }
                      },
                    )),
              ),
            ),
          ],
        );
      },
    );
  }

  String _titleText(WindDirection? windDirection) {
    if (windDirection == null) {
      return 'Wind';
    } else {
      return windDirectionToNameMap[windDirection] ?? '';
    }
  }
}
