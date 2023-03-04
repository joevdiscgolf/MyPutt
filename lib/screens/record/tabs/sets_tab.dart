import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:collection/collection.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row_v2.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SetsTab extends StatelessWidget {
  const SetsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          return ListView(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
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
                    deletable: true,
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
