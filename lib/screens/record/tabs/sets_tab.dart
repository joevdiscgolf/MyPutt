import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:collection/collection.dart';
import 'package:myputt/screens/record/components/rows/putting_set_row_v2.dart';

class SetsTab extends StatelessWidget {
  const SetsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionInProgressState) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: state.currentSession.sets
                .mapIndexed(
                  (index, set) => PuttingSetRowV2(
                    set: set,
                    index: index,
                    delete: () {
                      BlocProvider.of<SessionsCubit>(context).deleteSet(set);
                    },
                    deletable: true,
                  ),
                )
                .toList(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
