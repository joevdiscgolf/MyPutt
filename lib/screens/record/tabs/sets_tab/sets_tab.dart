import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/empty_state/empty_state_v2.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:collection/collection.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row_v2.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SetsTab extends StatelessWidget {
  const SetsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionActive) {
          if (state.currentSession.sets.isEmpty) {
            return const EmptyStateV2(
              title: 'No sets yet...',
              subtitle: 'Your sets will appear here',
              iconData: FlutterRemix.stack_line,
            );
          }

          return ListView(
            padding: const EdgeInsets.only(left: 24, top: 4),
            physics: const AlwaysScrollableScrollPhysics(),
            children: addDividers(
              [
                ...state.currentSession.sets.reversed.mapIndexed(
                  (index, set) => PuttingSetRowV2(
                    set: set,
                    index: state.currentSession.sets.length - 1 - index,
                    delete: () {
                      BlocProvider.of<SessionsCubit>(context).deleteSet(set);
                    },
                    onDelete: () {
                      Vibrate.feedback(FeedbackType.light);
                      locator
                          .get<Mixpanel>()
                          .track('Record Screen Set Deleted');
                      BlocProvider.of<SessionsCubit>(context).deleteSet(set);
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
