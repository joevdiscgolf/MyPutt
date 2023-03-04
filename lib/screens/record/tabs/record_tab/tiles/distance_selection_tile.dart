import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/adjust_distance_button.dart';
import 'package:myputt/screens/record/tabs/record_tab/tiles/selection_tile.dart';
import 'package:myputt/utils/colors.dart';

class DistanceSelectionTile extends StatelessWidget {
  const DistanceSelectionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Distance',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MyPuttColors.gray[400],
                  ),
            ),
            const SizedBox(height: 8),
            SelectionTile(
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: AdjustDistanceButton(increment: false),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: MyPuttColors.gray[200]!,
                      thickness: 1,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${state.distance}',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: MyPuttColors.darkGray,
                            ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: MyPuttColors.gray[200]!,
                      thickness: 1,
                    ),
                    const Expanded(
                      child: AdjustDistanceButton(increment: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
