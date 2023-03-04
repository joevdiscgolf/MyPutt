import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/circle_icon_container.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/select_no_condition_row.dart';
import 'package:myputt/utils/colors.dart';
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
                    Vibrate.feedback(FeedbackType.light);
                    BlocProvider.of<RecordCubit>(context)
                        .updateWindDirection(windDirection);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(FlutterRemix.windy_line),
                  title: '${windDirectionToNameMap[windDirection]}',
                );
              },
            ),
            SelectNoConditionRow(
              onPressed: () {
                Vibrate.feedback(FeedbackType.light);
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

class ConditionSelectionRow extends StatelessWidget {
  const ConditionSelectionRow({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final Function onPressed;
  final Widget icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleIconContainer(icon: icon),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MyPuttColors.gray[800]!,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subtitle!,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: MyPuttColors.gray[400]!),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
