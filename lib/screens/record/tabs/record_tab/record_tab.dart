import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/record_add_set_button.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/stats_seciton.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/quantity_row.dart';
import 'package:myputt/screens/record/tabs/record_tab/components/selection_tiles.dart';
import 'package:myputt/utils/constants.dart';

class RecordTab extends StatelessWidget {
  const RecordTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Column(
            children: [
              const SelectionTilesRow(),
              const SizedBox(height: 32),
              const QuantityRow(),
              const SizedBox(height: 4),
              PuttsMadePicker(
                height: MediaQuery.of(context).size.height <= kIPhone8Height
                    ? 116
                    : 124,
                length: state.setLength,
                initialIndex: state.setLength.toDouble(),
                challengeMode: false,
                sslKey: state.puttsPickerKey,
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
      },
    );
  }
}
