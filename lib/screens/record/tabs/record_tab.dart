import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/screens/record/components/add_set_button.dart';
import 'package:myputt/screens/record/components/record_tab/quantity_row.dart';
import 'package:myputt/screens/record/components/record_tab/selection_tiles.dart';
import 'package:myputt/screens/record/components/stats_seciton.dart';

class RecordTab extends StatelessWidget {
  const RecordTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        if (state is RecordActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Column(
              children: [
                const SelectionTilesRow(),
                const SizedBox(height: 32),
                const QuantityRow(),
                const SizedBox(height: 4),
                PuttsMadePicker(
                  length: state.setLength,
                  initialIndex: state.setLength.toDouble(),
                  challengeMode: false,
                  sslKey: state.sslKey,
                  onUpdate: (int newIndex) {
                    BlocProvider.of<RecordCubit>(context)
                        .updatePuttsSelected(newIndex);
                  },
                ),
                const Expanded(child: StatsSection()),
                const RecordAddSetButton(),
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
